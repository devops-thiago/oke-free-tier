# Testing

This directory contains Terratest-based tests for the OCI Kubernetes infrastructure.

## Prerequisites

- Go 1.19 or later
- Terraform
- Access to the project root directory

## Running Tests

To run all tests:

```bash
go test -v ./test/
```

## Tests Included

1. **TestTerraformValidation**: Validates the Terraform configuration syntax and structure
2. **TestTerraformFormat**: Ensures the Terraform code is properly formatted

## Test Benefits

- **No API calls**: Tests validate configuration without requiring real OCI resources
- **Fast execution**: Tests complete in seconds
- **CI/CD friendly**: Can be integrated into build pipelines
- **Mock-friendly**: Uses Terratest's validation capabilities without provisioning

## Adding New Tests

To add new tests, create functions following the pattern:

```go
func TestMyNewTest(t *testing.T) {
    t.Parallel()
    // Test implementation
}
```

Tests should focus on configuration validation rather than resource provisioning to keep them fast and reliable.
