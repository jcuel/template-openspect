# Testing Report: <title>

**Change:** `<change-name>`
**Date:** YYYY-MM-DD

## Test Results

| Suite | Command | Result | Notes |
|-------|---------|--------|-------|
| Unit | | pass / fail / skipped | |
| Integration | | pass / fail / skipped | |
| Container smoke | | pass / fail / skipped | |

## Verify Checklist

- [ ] All tests pass
- [ ] Container smoke test run (or documented as unavailable)
- [ ] Security review noted (manual until CI scans are configured)
- [ ] Acceptance criteria from `user-story.md` verified

## CI Security Scans (when configured)

| Scan | Tool | Result | Notes |
|------|------|--------|-------|
| Dependency vulnerabilities | govulncheck / npm audit / etc. | pass / fail / n/a | |
| Filesystem CVEs | Trivy FS | pass / fail / n/a | |
| Container image CVEs | Trivy image | pass / fail / n/a | |
| Secrets in repo | manual / gitleaks | pass / fail / n/a | |

## Code Review Notes

<!-- Filled by /code-review. -->

| Severity | Finding | Resolution |
|----------|---------|------------|
| | | |

## Summary

Overall readiness: ready / blocked
