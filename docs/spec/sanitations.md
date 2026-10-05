_Author_:  @DimuthuMadushan \
_Created_: 02-10-2026 \
_Updated_: 05-10-2026 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Zuora Revenue.
The OpenAPI specification is obtained from [wso2/api-specs](https://github.com/wso2/api-specs/blob/main/openapi/zuora/revenue/2025-08-06/openapi.yaml).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

## Sanitization Details

1. Define the `basicAuth` security scheme
- **Original**: The Authentication operation references `basicAuth` in its `security` list, but `components.securitySchemes` does not define it.
- **Updated**: Added `components.securitySchemes.basicAuth` with `type: http` and `scheme: basic`.
- **Reason**: Without a scheme the client has no `auth` configuration and the operation references an undefined scheme.

2. Rename the `tmpl_name` path parameter of `POST /v1/biviews/{viewName}`
- **Original**: The path template uses `{view_name}`, but the POST operation declares the path parameter as `tmpl_name`.
- **Updated**: The parameter is named `view_name` (`viewName` after alignment), matching the path template.
- **Reason**: A path template variable without a matching `in: path` parameter makes `bal openapi` drop the operation.

3. Remove the request body of `GET /v2/biviews/{viewName}`
- **Original**: The GET operation declares a required JSON `requestBody` (a list of field names).
- **Updated**: The `requestBody` is removed.
- **Reason**: A GET operation cannot carry a request body in the generated client. The field selection is available with the v1 POST operation on the same view.

4. Use `application/json` for request bodies declared as `application/json; charset=utf-8`
- **Original**: The request bodies of `POST /v1/biviews/{viewName}`, `POST /v1/job/collection/template` and `POST /v1/{orgId}/programs/{programId}/submit` use the media type `application/json; charset=utf-8`.
- **Updated**: The media type is `application/json`.
- **Reason**: `bal openapi` drops operations whose request body media type carries a parameter.

5. Return the BI view download of `GET /v2/biviews/{viewName}` as bytes
- **Original**: The 200 response is `string` / `binary` content under `application/json; charset=utf-8`.
- **Updated**: The content type is `application/octet-stream`.
- **Reason**: The response is a CSV or gzip file; the client now returns `byte[]` instead of a file record.

6. Tighten operation summaries, descriptions and parameter descriptions
- **Original**: Several method-level docs are vague or misleading: success responses described only as "Operation is successful", `GET_CollectionDetails` reports "The request is submitted successfully", the BI view download response reads "csv or gzip format desired format", `POST /v1/biviews/{viewName}` has a one-line description, the `role`/`clientname` header parameters of the Authentication operation have no description, and a few summaries name the wrong object.
- **Updated**: Reworded in Zuora Revenue terms. Operations touched: `GET_TransferBatch`, `GET_TransferBatchList`, `GET_TransferBatchFile`, `GET_ReportList`, `GET_DownloadReports` and `GET_CollectionDetails` (200 response descriptions); `GET_BIView` (200 response description); `POST_BIViews` (description); `POST_Authenticate` (`role` and `clientname` parameter descriptions); `GET_RevenueJobStatus` (`jobId` parameter description); `GET_ReportsURL` (summary "Get report signed URL"), `GET_AllTaskStatus` (summary "Get all BI view task status"), `DELETE_Task` (summary "Cancel BI view download tasks") and `GET_RowCount` (summary "Get BI view row count").
- **Reason**: The summaries, descriptions and `# + return` lines become the doc comments of the client methods, so they should say what each call does and returns.

7. Replace `info.description` with a short client summary
- **Original**: `info.description` holds the vendor's full API reference introduction (about 3,400 characters of overview, requirements and inbound data error notes).
- **Updated**: `info.description` is replaced with a one-sentence summary of the connector: "This is the client for the Zuora Revenue REST API, used to upload data, track uploads and staging errors, download BI view data and reports, transfer accounting batches, and submit and monitor revenue programs and data collection jobs."
- **Reason**: `bal openapi` copies `info.description` into the doc comment of the generated `Client` class; the vendor text was a long portal introduction, so a short client summary is used instead.

8. Declare response bodies for the download, row count and column list operations
- **Original**: The 200 responses of `GET /api/integration/v1/biviews/{view_name}` (`GET_BIViews`, `getBiViews`), `POST /api/integration/v1/biviews/{view_name}` (`POST_BIViews`, `getBiViewsForFields`), `GET /api/integration/v1/reports/download/{filename}` (`GET_DownloadReports`, `downloadReport`), `GET /api/integration/v2/biviews/count/{tmpl_name}` (`GET_RowCount`, `getBiViewRowCount`) and `GET /api/integration/v2/biviews/{tmpl_name}/describe-columns` (`GET_ColumnList`, `listBiViewColumns`) declare no content, so the generated methods return only `error?`.
- **Updated**: The three downloads return `application/octet-stream` with a `string` / `binary` schema (so the methods return `byte[]`). The row count and column list return `application/json` with a minimal open object schema (`type: object`, `additionalProperties: true`). Applied to `docs/spec/openapi.yaml`. The spec gives no example or field list for the row count and column list bodies, so no fields were invented.
- **Reason**: Callers need the downloaded file and the returned JSON; without a declared body the client discards it.

9. Send the `POST /api/integration/v1/csv/upload` request body as a single string
- **Original**: The `text/plain` request body of `POST /api/integration/v1/csv/upload` (`POST_Upload`) is an array of strings.
- **Updated**: The schema is `type: string`, keeping the `text/plain` media type. Applied to `docs/spec/openapi.yaml`.
- **Reason**: The body is the raw CSV text (the operation description calls it a CSV file); an array of strings would not be sent as one text body.

10. Change the `url` property of the servers object
- **Original**: `https://yourHost`
- **Updated**: `https://yourHost/api/integration`
- **Reason**: Common prefix added to base URL to simplify endpoint paths.
<!-- auto-generated -->

11. Update the API Paths
- **Original**: Paths included common prefix `/api/integration` in each endpoint.
- **Updated**: Common prefix removed from endpoints as it is now in the base URL.
- **Reason**: Simplifies API paths and avoids duplication.
<!-- auto-generated -->

12. Update `date-time` to `datetime`
- **Original**: `"format":"date-time"`
- **Updated**: `"format":"datetime"`
- **Reason**: The `date-time` format is not compatible with the openAPI generation tool. Updated to `datetime` for Ballerina compatibility.
<!-- auto-generated -->

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json --mode client --license docs/license.txt --client-methods remote -o ballerina
```

Generate with Ballerina 2201.13.4; the package declares 2201.12.0 (`postfix.py` sets the declared distribution).

### Post-generation step

After every regeneration, `uploadFile` in `ballerina/client.bal` must call `createBodyParts(payload)` instead of `createBodyParts(check jsondata:toJson(payload).ensureType())`. This is the known multipart byte-array defect (the file bytes are otherwise sent as a JSON int array). No spec change can express it, and it must be re-applied after every regeneration.

Note: The license year is hardcoded to 2026, change if necessary.
