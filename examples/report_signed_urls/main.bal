import ballerina/io;
import ballerinax/zuora.revenue;

configurable string serviceUrl = ?;
configurable string username = ?;
configurable string password = ?;
configurable string role = ?;
configurable string clientName = ?;
configurable string createdDate = ?;

public function main() returns error? {
    revenue:Client revenueClient = check new ({auth: {username, password}}, serviceUrl);

    // Step 1: Authenticate and get a token for the subsequent calls.
    revenue:AuthenticationResponse auth = check revenueClient->createAuthentication({role, clientname: clientName});
    string token = auth.Message;

    // Step 2: List the reports created on the given date.
    revenue:ReportListResponse reports = check revenueClient->listReports({token}, createddate = createdDate);
    revenue:ReportList[] reportList = reports?.Result ?: [];
    if reportList.length() == 0 {
        return error("No reports found for " + createdDate);
    }

    // Step 3: Fetch a signed download URL for every report.
    foreach revenue:ReportList report in reportList {
        int? reportId = report?.id;
        if reportId is () {
            continue;
        }
        revenue:ReportSignedUrlResponse signed = check revenueClient->getReportSignedUrl(reportId, {token});
        io:println(string `${report?.repName ?: "Unnamed report"} (${reportId}): ${signed?.signed_url.toString()}`);
    }
}
