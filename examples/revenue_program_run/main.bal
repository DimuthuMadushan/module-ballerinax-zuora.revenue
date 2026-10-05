import ballerina/io;
import ballerina/lang.runtime;
import ballerinax/zuora.revenue;

configurable string serviceUrl = ?;
configurable string username = ?;
configurable string password = ?;
configurable string role = ?;
configurable string clientName = ?;
configurable int orgId = ?;
configurable int programId = ?;
configurable int parameterId = ?;
configurable string parameterValue = ?;
configurable boolean submitProgram = false;
configurable int maxPolls = 10;

public function main() returns error? {
    revenue:Client revenueClient = check new ({auth: {username, password}}, serviceUrl);

    // Step 1: Authenticate (the token is only needed by the token based operations).
    revenue:AuthenticationResponse auth = check revenueClient->createAuthentication({role, clientname: clientName});
    io:println("Authentication status: ", auth.status);

    // Step 2: Confirm the program exists.
    revenue:ProgramDetailsResponse programs = check revenueClient->listPrograms();
    revenue:ProgramDetail[] programList = programs.data ?: [];
    string programIdText = programId.toString();
    revenue:ProgramDetail[] matches = from revenue:ProgramDetail p in programList
        where p?.programId == programIdText
        select p;
    if matches.length() == 0 {
        return error("Program " + programIdText + " is not available");
    }
    io:println("Program: ", matches[0]?.programName);

    if !submitProgram {
        io:println("submitProgram is false; skipping the submission.");
        return;
    }

    // Step 3: Submit the program.
    revenue:JobStatusResponse submitted = check revenueClient->submitProgram(programId, orgId,
        {parameters: [{parameterId, sequence: 1, parameterValue}]});
    int? jobId = submitted.data?.id;
    if jobId is () {
        return error("The submission did not return a job ID");
    }

    // Step 4: Poll the job while it is Pending or Running. Only Completed counts as success; any other
    // status (Error, Warning, Failed, Cancelled, Terminated, Incompatible) or a missing status is an error.
    foreach int attempt in 1 ... maxPolls {
        revenue:JobStatusResponse job = check revenueClient->getJobStatus(jobId, orgId);
        string? status = job.data?.status;
        io:println(string `Job ${jobId} status: ${status ?: "unknown"}`);
        if status is () {
            return error(string `Job ${jobId} returned no status`);
        }
        if status == "Completed" {
            return;
        }
        if status != "Pending" && status != "Running" {
            return error(string `Job ${jobId} ended with status ${status}`);
        }
        runtime:sleep(5);
    }
    return error(string `Job ${jobId} did not finish after ${maxPolls} polls`);
}
