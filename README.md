# Ballerina Zuora Revenue connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-zuora.revenue/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-zuora.revenue/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-zuora.revenue.svg)](https://github.com/ballerina-platform/module-ballerinax-zuora.revenue/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/zuora.revenue.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Fzuora.revenue)

## Overview

[Zuora Revenue](https://www.zuora.com/products/revenue-recognition/) is a revenue recognition and accounting automation application that ingests transaction data from source ERP systems, creates revenue contracts and produces accounting and reporting data.

The Zuora Revenue connector lets Ballerina applications use the Zuora Revenue REST API to authenticate, upload transaction and event data, track uploads and staging errors, transfer accounting batches, download BI view data and reports, and submit and monitor revenue programs and data collection jobs. It supports version `2025-08-06` of the Zuora Revenue REST API.

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

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`zuora.revenue` package](https://central.ballerina.io/ballerinax/zuora.revenue/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
