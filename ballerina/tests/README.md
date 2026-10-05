# Running Tests

## Prerequisites

You need a Zuora Revenue API user to run the tests against the live service. By default the tests run against the mock service in `tests/mock_service.bal`, which covers 25 operations.

## Running tests

### Mock server

```bash
bal test --groups mock_tests
```

### Live server

Export the credentials and run the live tests:

```bash
export IS_LIVE_SERVER=true
export ZUORA_REVENUE_SERVICE_URL="https://<host>/api/integration"
export ZUORA_REVENUE_USERNAME="<username>"
export ZUORA_REVENUE_PASSWORD="<password>"
export ZUORA_REVENUE_TOKEN="<token returned by the Authentication operation>"
bal test --groups live_tests
```
