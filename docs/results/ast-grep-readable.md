# AST-grep Security Analysis Report
Generated: 2025-09-11 14:47:48
Project: Ruby SAST Survey
Total Findings: 5

## Summary by Severity
- error: 5 findings

## Detailed Findings

### Finding 1: command-injection
**File:** `controllers/payments_controller.rb`
**Line:** 11
**Severity:** error
**Message:** Potential command injection vulnerability
**Code:** `system(command)`

---

### Finding 2: sql-injection
**File:** `app.rb`
**Line:** 28
**Severity:** error
**Message:** Potential SQL injection vulnerability detected
**Code:** `db.execute("SELECT * FROM users WHERE id = #{params[:id]}")`

---

### Finding 3: command-injection
**File:** `models/user.rb`
**Line:** 30
**Severity:** error
**Message:** Potential command injection vulnerability
**Code:** `system("backup_script.sh #{self.id}")`

---

### Finding 4: sql-injection
**File:** `controllers/users_controller.rb`
**Line:** 7
**Severity:** error
**Message:** Potential SQL injection vulnerability detected
**Code:** `User.where("name LIKE '%#{params[:q]}%'")`

---

### Finding 5: sql-injection
**File:** `controllers/users_controller.rb`
**Line:** 23
**Severity:** error
**Message:** Potential SQL injection vulnerability detected
**Code:** `User.where("role = 'admin' AND name LIKE '%#{sanitized_term}%'")`

---

