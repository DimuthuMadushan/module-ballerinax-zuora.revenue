# Revenue program run

This example authenticates against Zuora Revenue, confirms that a revenue program is available, and optionally submits it for an organization. It then polls the job until it leaves the pending and running states. The program is only submitted when `submitProgram` is set to `true`.

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
orgId = <organization-id>
programId = <program-id>
parameterId = <program-parameter-id>
parameterValue = "<program-parameter-value>"
submitProgram = false
maxPolls = 10
```

## Run the example

Execute the following command to run the example:

```bash
bal run
```
