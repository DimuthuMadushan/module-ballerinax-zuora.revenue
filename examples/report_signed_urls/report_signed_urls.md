# Report signed URLs

This example authenticates against Zuora Revenue, lists the reports that were created on a given date, and prints a signed download URL for each of them.

## Prerequisites

### 1. API user

Follow the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-zuora.revenue/blob/main/ballerina/README.md#setup-guide) to obtain the username, password, role and client name of a Zuora Revenue API user.

### 2. Configuration

Create a `Config.toml` file in this example's directory with the following content:

```toml
serviceUrl = "https://<host>/api/integration"
username = "<username>"
password = "<password>"
role = "<role>"
clientName = "<client-name>"
createdDate = "<report-creation-date>"
```

## Run the example

Execute the following command to run the example:

```bash
bal run
```
