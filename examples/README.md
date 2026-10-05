# Examples

The `ballerinax/zuora.revenue` connector provides practical examples illustrating usage in various scenarios.

1. [Report signed URLs](./report_signed_urls/report_signed_urls.md) - List the reports created on a date and fetch a signed download URL for each.
2. [Revenue program run](./revenue_program_run/revenue_program_run.md) - Confirm a revenue program exists, submit it and poll the resulting job until it finishes.

## Prerequisites

Each example needs a Zuora Revenue API user. Follow the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-zuora.revenue/blob/main/ballerina/README.md#setup-guide) to obtain the username, password, role and client name, and create a `Config.toml` in the example's directory.

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
