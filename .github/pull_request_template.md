# Pull Request

## 📋 PR Checklist

### Pre-Submission Checklist

- [ ] **Code Quality**

  - [ ] Code follows project coding standards
  - [ ] ESLint passes with no errors or warnings
  - [ ] Prettier formatting applied
  - [ ] TypeScript compilation successful
  - [ ] No console.log statements left in production code

- [ ] **Testing**

  - [ ] Unit tests written and passing
  - [ ] Integration tests updated if needed
  - [ ] Test coverage meets 80% minimum requirement
  - [ ] All existing tests still pass

- [ ] **Documentation**

  - [ ] Code is self-documenting with clear variable/function names
  - [ ] Complex logic has inline comments
  - [ ] README updated if needed
  - [ ] API documentation updated if applicable

- [ ] **Security**
  - [ ] No sensitive data exposed in code or logs
  - [ ] Input validation implemented where needed
  - [ ] Dependencies checked for security vulnerabilities

### Automated Checks

- [ ] **CI/CD Pipeline**
  - [ ] All GitHub Actions checks pass
  - [ ] Code coverage requirements met (80% minimum)
  - [ ] Security scanning completed
  - [ ] Build successful
  - [ ] Coverage thresholds enforced
  - [ ] Required status checks pass

## 🎯 Description

<!-- Provide a clear and concise description of the changes -->

### What does this PR do?

<!-- Explain the purpose and scope of the changes -->

### Why is this change needed?

<!-- Describe the problem this solves or the feature it adds -->

### How was this tested?

<!-- Describe the testing approach and what was verified -->

## 📊 Impact Assessment

### Breaking Changes

- [ ] This PR introduces breaking changes
- [ ] This PR is backward compatible

### Performance Impact

- [ ] No performance impact
- [ ] Performance improvements
- [ ] Performance regression (explain below)

### Security Impact

- [ ] No security impact
- [ ] Security improvements
- [ ] Security considerations (explain below)

## 🔗 Related Issues

<!-- Link to any related issues, discussions, or documentation -->

Closes #(issue number)
Related to #(issue number)

## 📝 Additional Notes

<!-- Any additional context, screenshots, or information that reviewers should know -->

## 🧪 Testing Instructions

<!-- Step-by-step instructions for testing this PR -->

1. **Setup**: `npm install`
2. **Test**: `npm test`
3. **Lint**: `npm run lint`
4. **Build**: `npm run build`
5. **Manual Testing**: [Describe manual testing steps]

## ✅ Review Checklist for Maintainers

- [ ] Code review completed
- [ ] Tests pass locally
- [ ] Documentation updated
- [ ] Security review completed
- [ ] Performance impact assessed
- [ ] Breaking changes documented
- [ ] Release notes updated (if applicable)

---

**Note**: This PR will be automatically blocked if any of the required checks fail. Please ensure all automated tests pass before requesting review.
