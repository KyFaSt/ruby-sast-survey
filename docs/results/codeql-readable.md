# CodeQL Security Analysis Report
Generated: 2025-09-11 14:47:48
Project: Ruby SAST Survey
CodeQL Version: 2.23.0
Total Findings: 10

## Summary by Severity
- error: 8 findings
- warning: 2 findings

## Summary by Rule Type
- rb/code-injection: 1 findings
- rb/command-line-injection: 2 findings
- rb/csrf-protection-not-enabled: 2 findings
- rb/path-injection: 1 findings
- rb/sql-injection: 3 findings
- rb/url-redirection: 1 findings

## Detailed Findings

### Finding 1: rb/code-injection
**File:** `app.rb`
**Line:** 62
**Severity:** error
**Message:** This code execution depends on a [user-provided value](1).
**CWE:** external/cwe/cwe-094, external/cwe/cwe-095, external/cwe/cwe-116

---

### Finding 2: rb/url-redirection
**File:** `controllers/users_controller.rb`
**Line:** 12
**Severity:** error
**Message:** Untrusted URL redirection depends on a [user-provided value](1).
**CWE:** external/cwe/cwe-601

---

### Finding 3: rb/sql-injection
**File:** `controllers/users_controller.rb`
**Line:** 8
**Severity:** error
**Message:** This SQL query depends on a [user-provided value](1).
**CWE:** external/cwe/cwe-089

---

### Finding 4: rb/sql-injection
**File:** `controllers/users_controller.rb`
**Line:** 24
**Severity:** error
**Message:** This SQL query depends on a [user-provided value](1).
**CWE:** external/cwe/cwe-089

---

### Finding 5: rb/sql-injection
**File:** `app.rb`
**Line:** 29
**Severity:** error
**Message:** This SQL query depends on a [user-provided value](1).
**CWE:** external/cwe/cwe-089

---

### Finding 6: rb/csrf-protection-not-enabled
**File:** `controllers/payments_controller.rb`
**Line:** 2
**Severity:** warning
**Message:** Potential CSRF vulnerability due to forgery protection not being enabled.
**CWE:** external/cwe/cwe-352

---

### Finding 7: rb/csrf-protection-not-enabled
**File:** `controllers/users_controller.rb`
**Line:** 5
**Severity:** warning
**Message:** Potential CSRF vulnerability due to forgery protection not being enabled.
**CWE:** external/cwe/cwe-352

---

### Finding 8: rb/path-injection
**File:** `app.rb`
**Line:** 52
**Severity:** error
**Message:** This path depends on a [user-provided value](1).
**CWE:** external/cwe/cwe-022, external/cwe/cwe-023, external/cwe/cwe-036, external/cwe/cwe-073, external/cwe/cwe-099

---

### Finding 9: rb/command-line-injection
**File:** `controllers/payments_controller.rb`
**Line:** 12
**Severity:** error
**Message:** This command depends on a [user-provided value](1).
**CWE:** external/cwe/cwe-078, external/cwe/cwe-088

---

### Finding 10: rb/command-line-injection
**File:** `app.rb`
**Line:** 44
**Severity:** error
**Message:** This command depends on a [user-provided value](1).
**CWE:** external/cwe/cwe-078, external/cwe/cwe-088

---

