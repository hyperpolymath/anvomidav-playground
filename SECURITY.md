# Security Policy

We take security seriously. Anvomidav is designed for safety-critical real-time systems where security is paramount.

## Reporting a Vulnerability

### Preferred Method: GitHub Security Advisories

1. Navigate to [Report a Vulnerability](https://github.com/hyperpolymath/anvomidav-playground/security/advisories/new)
2. Click **"Report a vulnerability"**
3. Complete the form with as much detail as possible

### Alternative: Email

| | |
|---|---|
| **Email** | hyperpolymath@proton.me |

> **Important:** Do not report security vulnerabilities through public GitHub issues.

## Scope

### Qualifying Vulnerabilities

For real-time systems, we're particularly interested in:

- **Timing vulnerabilities**: WCET violations, deadline misses
- **Verification bypass**: Proof soundness issues
- **Schedulability attacks**: Resource exhaustion
- **Memory safety issues**: Critical for embedded systems
- **Formal proof soundness**: Verification tool correctness

### Safety-Critical Considerations

Given Anvomidav's focus on verified real-time systems:

- Timing analysis correctness is security-critical
- Proof checker soundness is paramount
- Schedulability guarantees must hold

## Response Timeline

| Stage | Timeframe |
|-------|-----------|
| **Initial Response** | 24 hours (critical), 48 hours (normal) |
| **Triage** | 7 days |
| **Resolution** | 90 days |

---

*Thank you for helping keep Anvomidav and safety-critical systems secure.*

<sub>Last updated: 2025</sub>
