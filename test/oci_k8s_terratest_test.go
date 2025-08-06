package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformValidation(t *testing.T) {
	t.Parallel()

	// The path to the Terraform code that will be tested.
	terraformDir := "../"

	// Configure Terraform options for basic syntax validation.
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: terraformDir,
	}

	// Run `terraform init` to download providers and modules
	terraform.Init(t, terraformOptions)

	// Run `terraform validate` to check configuration syntax
	// This validates syntax without requiring variables or API calls
	terraform.Validate(t, terraformOptions)

	// Test passes if validation succeeds without errors
	assert.True(t, true, "Terraform configuration validation passed")
}

// Test configuration structure without API calls
func TestTerraformFormat(t *testing.T) {
	t.Parallel()

	// The path to the Terraform code that will be tested.
	terraformDir := "../"

	// Configure Terraform options
	terraformOptions := &terraform.Options{
		TerraformDir: terraformDir,
	}

	// Check if terraform fmt would make changes (indicating poor formatting)
	formatDiff := terraform.RunTerraformCommandAndGetStdout(t, terraformOptions, "fmt", "-check", "-diff")

	// If no output, formatting is correct
	assert.Empty(t, formatDiff, "Terraform code should be properly formatted")
}

