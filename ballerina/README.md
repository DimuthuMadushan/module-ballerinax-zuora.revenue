## Overview

[Zuora Revenue](https://www.zuora.com/products/revenue-recognition/) is a revenue recognition and accounting automation application that ingests transaction data from source ERP systems, creates revenue contracts and produces accounting and reporting data.

The Zuora Revenue connector lets Ballerina applications use the Zuora Revenue REST API to authenticate, upload transaction and event data, track uploads and staging errors, transfer accounting batches, download BI view data and reports, and submit and monitor revenue programs and data collection jobs. It supports version `2025-08-06` of the Zuora Revenue REST API.

### Key features

- Authenticate against Zuora Revenue and obtain the token used by the other operations
- Upload transaction, event and bundle configuration data as CSV files, and track upload status and staging errors
- List and update accounting transfer batches and download their files
- Query BI views, monitor their download tasks and list generated reports with signed download URLs
- Submit revenue programs and data collection jobs, and monitor the resulting jobs

## Setup guide

To use the Zuora Revenue connector, you need a Zuora Revenue tenant and an API user.

1. Ask your Zuora Revenue administrator to create a user that has an API role, for example `API Role`, and note the username, password, role name and client name.

2. Note the host of your Zuora Revenue tenant. The connector's service URL is `https://<host>/api/integration`.

3. Call the Authentication operation with the username and password as HTTP basic credentials. The connector sends the credentials as basic authentication and the response contains the token that the other operations take in their `token` header. A token is valid for 30 minutes by default; call the operation again to get a new one.

## Quickstart

To use the `zuora.revenue` connector in your Ballerina application, modify the `.bal` file as follows.

#### Step 1: Import the module

```ballerina
import ballerinax/zuora.revenue;
```

#### Step 2: Instantiate a new connector

Create a `Config.toml` file with your credentials and service URL.

```toml
username = "<username>"
password = "<password>"
role = "<role>"
clientName = "<client-name>"
serviceUrl = "https://<host>/api/integration"
```

Then create the client.

```ballerina
configurable string username = ?;
configurable string password = ?;
configurable string role = ?;
configurable string clientName = ?;
configurable string serviceUrl = ?;

final revenue:Client revenueClient = check new ({auth: {username, password}}, serviceUrl);
```

#### Step 3: Invoke the connector operation

```ballerina
public function main() returns error? {
    revenue:AuthenticationResponse _ = check revenueClient->createAuthentication({role, clientname: clientName});
}
```

#### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The `Zuora Revenue` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-zuora.revenue/tree/main/examples/), covering the following use cases:

1. [Report signed URLs](https://github.com/ballerina-platform/module-ballerinax-zuora.revenue/tree/main/examples/report_signed_urls) - List the reports created on a date and fetch a signed download URL for each.
2. [Revenue program run](https://github.com/ballerina-platform/module-ballerinax-zuora.revenue/tree/main/examples/revenue_program_run) - Confirm a revenue program exists, submit it and poll the resulting job until it finishes.
