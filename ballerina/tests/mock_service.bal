// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;

listener http:Listener ep0 = new (9090);

service / on ep0 {
    # Cancel task
    #
    # + token - The valid authentication token
    # + taskId - The continuation token associated with the tasks to be canceled
    # + return - The tasks are canceled
    resource function delete v2/biviews\-status/[string taskId](@http:Header string token) returns http:Ok|http:NoContent {
        return http:OK;
    }

    # Get the job status
    #
    # + jobId - The ID of the job
    # + orgId - The ID of the organization
    # + return - The job status is returned
    resource function get v1/[int orgId]/jobs/[int jobId]() returns JobStatusResponse|http:BadRequest {
        return {
            data: {
                id: jobId,
                status: "Completed",
                crtdBy: "APIUSER",
                crtdDt: "2025-08-01T10:15:30",
                updtDt: "2025-08-01T10:20:41",
                actualStartDate: "2025-08-01T10:15:35",
                secAtrVal: orgId
            },
            success: true
        };
    }

    # Get upload status
    #
    # + token - The valid authentication token
    # + id - The request ID of the uploaded file
    # + return - The status information is returned
    resource function get v1/csv/upload/status(@http:Header string token, int id) returns UploadStatusResponse|http:BadRequest {
        return {
            result: {id: id, message: "Data Received", clientId: 1, status: "Successfully Uploaded"},
            status: "Success"
        };
    }

    # Get transfer batch file
    #
    # + token - The valid authentication token
    # + batchId - The batch ID of the transfer accounting batch
    # + return - The batch file content
    resource function get v1/download/transferbatchfile/[int batchId](@http:Header string token) returns TransferBatchFileResponse|http:NoContent {
        return {active: [{"batchId": batchId, "file": "TRANSFER_BATCH_1001.csv"}]};
    }

    # Get file upload status
    #
    # + token - The valid authentication token
    # + fileRequestId - The request ID of the file upload
    # + return - The status information of the file upload
    resource function get v1/fileupload/status/[int fileRequestId](@http:Header string token) returns FileUploadStatusResponse|http:NoContent {
        return {
            Result: [{fileRequestId: fileRequestId, fileLog: "File processed with 120 records"}],
            message: "Data Staged Successfully",
            status: "Success"
        };
    }

    # Get data collection job details
    #
    # + jobId - The ID of the data collection job
    # + return - The job details
    resource function get v1/job/collection/template/[int jobId]() returns RevenueJobDetail|http:Unauthorized|http:Forbidden {
        return {
            data: {
                id: jobId,
                status: "Completed",
                crtdBy: "APIUSER",
                crtdDt: "2025-08-01T09:00:00",
                updtDt: "2025-08-01T09:05:12",
                actualStartDate: "2025-08-01T09:00:05"
            },
            success: true
        };
    }

    # Get transfer batch
    #
    # + token - The valid authentication token
    # + batchid - The batch ID
    # + pagenum - The page number
    # + pagesize - The page size
    # + return - The batch status
    resource function get v1/journal/batch/[int batchid]/[int pagenum](@http:Header string token, int? pagesize) returns TransferBatchStatusResponse {
        return {status: "Success"};
    }

    # List transfer batches
    #
    # + token - The valid authentication token
    # + return - The list of transfer batches
    resource function get v1/journal/list(@http:Header string token) returns TransferBatchListResponse|http:NoContent|http:BadRequest {
        return {
            result: [
                {
                    id: 1001,
                    name: "JOURNAL_BATCH_2025_08",
                    status: "Transferred",
                    clientId: 1,
                    crtdBy: "APIUSER",
                    crtdDt: "2025-08-01T08:00:00",
                    updtBy: "APIUSER",
                    updtDt: "2025-08-01T08:30:00",
                    reportId: 12
                },
                {
                    id: 1002,
                    name: "JOURNAL_BATCH_2025_09",
                    status: "Pending",
                    clientId: 1,
                    crtdBy: "APIUSER",
                    crtdDt: "2025-09-01T08:00:00",
                    updtBy: "APIUSER",
                    updtDt: "2025-09-01T08:00:00",
                    reportId: 13
                }
            ],
            status: "Success"
        };
    }

    # List programs
    #
    # + return - The list of programs
    resource function get v1/programs() returns ProgramDetailsResponse|http:BadRequest {
        return {
            data: [
                {
                    programName: "Revenue Contract Creation",
                    programId: "1005",
                    parameters: [
                        {id: 1002, name: "Business Unit", sequence: "1", 'type: "NUMBER", mandatory: "Y"},
                        {id: 1003, name: "Period", sequence: "2", 'type: "DATE", mandatory: "N"}
                    ]
                }
            ]
        };
    }

    # Download a report
    #
    # + token - The valid authentication token
    # + filename - The report file name
    # + return - The report content
    resource function get v1/reports/download/[string filename](@http:Header string token) returns http:Ok|http:NoContent {
        return http:OK;
    }

    # List reports
    #
    # + token - The valid authentication token
    # + createddate - Filter by report creation date
    # + return - The list of reports
    resource function get v1/reports/list(@http:Header string token, string? createddate) returns ReportListResponse|http:BadRequest {
        return {
            Message: "Reports listed",
            Result: [
                {
                    id: 501,
                    repName: "Revenue Waterfall",
                    repDesc: "Monthly revenue waterfall report",
                    layoutName: "Default",
                    fileName: "revenue_waterfall_2025_08.csv",
                    category: "Revenue",
                    reportDate: "2025-08-31",
                    status: "Completed"
                }
            ],
            status: "Success"
        };
    }

    # List revenue organizations
    #
    # + return - The list of organizations
    resource function get v1/revenue\-orgs() returns ProgramDetailsResponse|http:BadRequest {
        return {
            data: [
                {programName: "US Operations", programId: "101"},
                {programName: "EMEA Operations", programId: "102"}
            ]
        };
    }

    # Get staging errors
    #
    # + token - The valid authentication token
    # + errortype - The type of staged data
    # + return - The staging errors
    resource function get v1/stage/'error/["transaction"|"event" errortype](@http:Header string token) returns StagingErrorResponse|http:NoContent {
        return {
            Result: [
                {
                    id: 9001,
                    uploadId: "77",
                    'type: errortype,
                    errMsg: "Invalid transaction date format",
                    soNum: "SO-1001",
                    soLineId: "1",
                    soLineNum: "1",
                    clientId: 1,
                    processedFlag: "N",
                    crtdBy: "APIUSER",
                    crtdDt: "2025-08-01T10:00:00"
                }
            ],
            status: "Success"
        };
    }

    # Get field mapping
    #
    # + token - The valid authentication token
    # + templatename - The upload template name
    # + return - The field mapping
    resource function get v1/upload/mapping(@http:Header string token, string? templatename) returns FieldMappingResponse|http:BadRequest {
        return {
            Dateformat: "DD-MON-YYYY",
            Mapping: [
                {id: 1, uploadId: 10, colName: "SO_NUM", label: "Sales Order Number", dataType: "VARCHAR", seq: 1, clientId: 1},
                {id: 2, uploadId: 10, colName: "SO_LINE_NUM", label: "Sales Order Line", dataType: "NUMBER", seq: 2, clientId: 1}
            ]
        };
    }

    # List BI view columns
    #
    # + token - The valid authentication token
    # + tmplName - The BI view name
    # + return - The columns of the BI view
    resource function get v2/biviews/[string tmplName]/describe\-columns(@http:Header string token) returns http:Ok|http:BadRequest|http:Unauthorized {
        return http:OK;
    }

    # Get BI view row count
    #
    # + token - The valid authentication token
    # + tmplName - The BI view name
    # + clientId - The ID of the application user
    # + fromDate - The start date of the query
    # + toDate - The end date of the query
    # + return - The row count
    resource function get v2/biviews/count/[string tmplName](@http:Header string token, int clientId = 1, string fromDate = "2016-07-26T00:00:00", string toDate = "2018-07-26T00:00:00") returns http:Ok|http:BadRequest|http:Unauthorized {
        return http:OK;
    }

    # List BI view tasks
    #
    # + token - The valid authentication token
    # + return - The tasks grouped by state
    resource function get v2/biviews\-status(@http:Header string token) returns BiViewTaskListResponse|http:NoContent {
        return {
            result: {
                active: [
                    {
                        taskId: "task-1001",
                        metric: 4,
                        accumulate: 2,
                        message: "Download in progress",
                        status: "ACTIVE",
                        activityTracker: {initatedTime: "2025-08-01T10:00:00", lastActivity: "2025-08-01T10:01:00", elapsedTime: "60"},
                        queryConfig: {objectName: "BI3_RC_POB", filterParam: {fromDate: "2025-01-01", toDate: "2025-06-30"}}
                    }
                ],
                stale: [],
                draining: [],
                completed: []
            },
            status: "Success"
        };
    }

    # Get BI view task
    #
    # + token - The valid authentication token
    # + taskId - The task ID
    # + return - The task details
    resource function get v2/biviews\-status/[string taskId](@http:Header string token) returns BiViewTaskDetailsResponse|http:NoContent {
        return {
            active: [
                {
                    taskId: taskId,
                    metric: "4",
                    accumulate: 2,
                    message: "Download in progress",
                    status: "ACTIVE",
                    activityTracker: {initatedTime: "2025-08-01T10:00:00", lastActivity: "2025-08-01T10:01:00", elapsedTime: "60"},
                    queryConfig: {objectName: "BI3_RC_POB", filterParams: {fromDate: "2025-01-01", toDate: "2025-06-30"}}
                }
            ]
        };
    }

    # Get report signed URL
    #
    # + token - The valid authentication token
    # + reportId - The report ID
    # + return - The signed URL of the report
    resource function get v2/reports/signedurl/[int reportId](@http:Header string token) returns ReportSignedUrlResponse|http:BadRequest|http:NotFound {
        return {
            signed_url: "https://storage.zuora-revenue.example.net/reports/" + reportId.toString() + "?sig=abc123",
            success: true
        };
    }

    # Submit a program
    #
    # + orgId - The organization ID
    # + programId - The program ID
    # + payload - The program parameters
    # + return - The job status
    resource function post v1/[int orgId]/programs/[int programId]/submit(@http:Payload SubmitJobRequest payload) returns JobStatusResponse|http:BadRequest|http:Forbidden {
        return {
            data: {id: 7001, status: "Pending", crtdBy: "APIUSER", crtdDt: "2025-08-01T11:00:00", secAtrVal: orgId},
            success: true
        };
    }

    # Create authentication
    #
    # + role - The user role
    # + clientname - The client name
    # + return - The authentication token is returned
    resource function post v1/authenticate(@http:Header string role = "API Role", @http:Header string clientname = "Default") returns AuthenticationResponse {
        return {Message: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.mock-token", status: "success"};
    }

    # Create upload
    #
    # + token - The valid authentication token
    # + templatename - The upload template name
    # + filename - The name of the uploaded file
    # + request - The CSV payload
    # + return - The upload is staged
    resource function post v1/csv/upload(@http:Header string token, @http:Header string templatename, @http:Header string filename, http:Request request) returns CreateUploadResponse|http:BadRequest {
        return {
            message: "Data Staged Successfully",
            result: {id: 88, message: "Data Received", clientId: 1, status: "Successfully Uploaded"},
            status: "Success"
        };
    }

    # Create data collection job
    #
    # + payload - The collection job request
    # + return - The job is submitted
    resource function post v1/job/collection/template(@http:Payload RevenueJobRequest payload) returns RevenueJobResponse|http:Unauthorized|http:Forbidden {
        return {message: "Job submitted, job ID: 3001", success: true};
    }

    # Upload file
    #
    # + token - The valid authentication token
    # + templatename - The upload template name
    # + request - The multipart request
    # + return - The file is received
    resource function post v1/upload/file(@http:Header string token, @http:Header string templatename, http:Request request) returns UploadFileResponse|http:BadRequest {
        return {message: "File received successfully", status: "Success"};
    }

    # Update transfer batch status
    #
    # + token - The valid authentication token
    # + batchId - The batch ID
    # + return - The batch status is updated
    resource function put v1/journal/batch/status/[int batchId](@http:Header string token) returns TransferBatchStatusResponse|http:BadRequest {
        return {status: "Success"};
    }
}
