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
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? os:getEnv("ZUORA_REVENUE_SERVICE_URL") : "http://localhost:9090";
final string username = isLiveServer ? os:getEnv("ZUORA_REVENUE_USERNAME") : "test_user";
final string password = isLiveServer ? os:getEnv("ZUORA_REVENUE_PASSWORD") : "test_password";
final string authToken = isLiveServer ? os:getEnv("ZUORA_REVENUE_TOKEN") : "mock_token";

final Client zuoraClient = check new ({
    auth: {username, password},
    httpVersion: http:HTTP_1_1
}, serviceUrl);

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCreateAuthentication() returns error? {
    AuthenticationResponse response = check zuoraClient->createAuthentication({role: "API Role", clientname: "Default"});
    test:assertEquals(response.status, "success");
    test:assertTrue(response.Message.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetFileUploadStatus() returns error? {
    FileUploadStatusResponse? response = check zuoraClient->getFileUploadStatus(12333, {token: authToken});
    test:assertTrue(response?.Result !is ());
}

@test:Config {groups: ["mock_tests"]}
function testUploadFile() returns error? {
    UploadFileResponse response = check zuoraClient->uploadFile(
        {token: authToken, templatename: "TRANSACTION_TEMPLATE", contentType: "multipart/form-data"},
        {file: {fileContent: "SO_NUM,SO_LINE_NUM\nSO-1,1".toBytes(), fileName: "transactions.csv"}});
    test:assertEquals(response.status, "Success");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetUploadStatus() returns error? {
    UploadStatusResponse response = check zuoraClient->getUploadStatus({token: authToken}, id = 88);
    test:assertEquals(response.result?.id, 88);
}

@test:Config {groups: ["mock_tests"]}
function testCreateUpload() returns error? {
    CreateUploadResponse response = check zuoraClient->createUpload(
        {token: authToken, templatename: "TRANSACTION_TEMPLATE", filename: "transactions.csv"},
        ["SO_NUM,SO_LINE_NUM", "SO-1,1"]);
    test:assertEquals(response.status, "Success");
    test:assertTrue(response.result?.id is int);
}

@test:Config {groups: ["mock_tests"]}
function testUpdateTransferBatchStatus() returns error? {
    TransferBatchStatusResponse response = check zuoraClient->updateTransferBatchStatus(1001, {token: authToken});
    test:assertEquals(response.status, "Success");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetTransferBatch() returns error? {
    TransferBatchStatusResponse response = check zuoraClient->getTransferBatch(1001, 1, {token: authToken});
    test:assertEquals(response.status, "Success");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListTransferBatches() returns error? {
    TransferBatchListResponse? response = check zuoraClient->listTransferBatches({token: authToken});
    test:assertTrue(response?.result is Journal[]);
    Journal[] batches = response?.result ?: [];
    test:assertTrue(batches.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetTransferBatchFile() returns error? {
    TransferBatchFileResponse? response = check zuoraClient->getTransferBatchFile(1001, {token: authToken});
    test:assertTrue(response?.active !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListReports() returns error? {
    ReportListResponse response = check zuoraClient->listReports({token: authToken});
    ReportList[] reports = response?.Result ?: [];
    test:assertTrue(reports.length() > 0);
}

@test:Config {groups: ["mock_tests"]}
function testDownloadReport() returns error? {
    check zuoraClient->downloadReport("revenue_waterfall_2025_08.csv", {token: authToken});
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetReportSignedUrl() returns error? {
    ReportSignedUrlResponse response = check zuoraClient->getReportSignedUrl(501, {token: authToken});
    test:assertEquals(response?.success, true);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetStagingErrors() returns error? {
    StagingErrorResponse? response = check zuoraClient->getStagingErrors("transaction", {token: authToken});
    StageError[] errors = response?.Result ?: [];
    test:assertTrue(errors.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetFieldMapping() returns error? {
    FieldMappingResponse response = check zuoraClient->getFieldMapping({token: authToken});
    UploadMapping[] mappings = response?.Mapping ?: [];
    test:assertTrue(mappings.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListBiViewTasks() returns error? {
    BiViewTaskListResponse? response = check zuoraClient->listBiViewTasks({token: authToken});
    test:assertTrue(response?.result !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetBiViewTask() returns error? {
    BiViewTaskDetailsResponse? response = check zuoraClient->getBiViewTask("task-1001", {token: authToken});
    test:assertTrue(response?.active !is ());
}

@test:Config {groups: ["mock_tests"]}
function testCancelBiViewTask() returns error? {
    check zuoraClient->cancelBiViewTask("task-1001", {token: authToken});
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetBiViewRowCount() returns error? {
    check zuoraClient->getBiViewRowCount("BI3_RC_POB", {token: authToken});
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListBiViewColumns() returns error? {
    check zuoraClient->listBiViewColumns("BI3_RC_POB", {token: authToken});
}

@test:Config {groups: ["mock_tests"]}
function testCreateCollectionJob() returns error? {
    RevenueJobResponse response = check zuoraClient->createCollectionJob({rc_template_name: "RC_TEMPLATE", org_id: 101});
    test:assertEquals(response.success, true);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetCollectionJob() returns error? {
    RevenueJobDetail response = check zuoraClient->getCollectionJob(3001);
    test:assertEquals(response.data?.id, 3001);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListPrograms() returns error? {
    ProgramDetailsResponse response = check zuoraClient->listPrograms();
    ProgramDetail[] programs = response.data ?: [];
    test:assertTrue(programs.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListRevenueOrgs() returns error? {
    ProgramDetailsResponse response = check zuoraClient->listRevenueOrgs();
    ProgramDetail[] orgs = response.data ?: [];
    test:assertTrue(orgs.length() > 0);
}

@test:Config {groups: ["mock_tests"]}
function testSubmitProgram() returns error? {
    JobStatusResponse response = check zuoraClient->submitProgram(1005, 101,
        {parameters: [{parameterId: 1002, sequence: 1, parameterValue: "101"}]});
    test:assertEquals(response.success, true);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetJobStatus() returns error? {
    JobStatusResponse response = check zuoraClient->getJobStatus(7001, 101);
    test:assertEquals(response.data?.id, 7001);
}
