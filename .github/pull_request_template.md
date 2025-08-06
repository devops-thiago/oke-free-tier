## Description

Brief description of the changes in this PR.

## Type of Change

- [ ] 🐛 Bug fix (non-breaking change which fixes an issue)
- [ ] ✨ New feature (non-breaking change which adds functionality)
- [ ] 💥 Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] 📚 Documentation update
- [ ] 🔧 Configuration change
- [ ] 🧪 Test updates

## Infrastructure Changes

- [ ] New resources added
- [ ] Existing resources modified
- [ ] Resources removed
- [ ] No infrastructure changes

## Testing

- [ ] Tests pass locally (`go test -v ./test/`)
- [ ] Terraform validation passes (`terraform validate`)
- [ ] Terraform formatting is correct (`terraform fmt -check`)
- [ ] TFLint checks pass
- [ ] Security scan (tfsec) reviewed

## Checklist

- [ ] Code follows the project's coding standards
- [ ] Self-review of the code has been performed
- [ ] Code has been tested in a development environment
- [ ] Documentation has been updated (if applicable)
- [ ] All CI checks are passing

## Additional Notes

Any additional information, context, or screenshots that would be helpful for reviewers.

---

**⚠️ Note**: This PR will automatically run the following validations:
- Terraform format check
- Terraform validation
- TFLint static analysis
- tfsec security scanning
- Terratest execution

All checks must pass before merge is allowed.
