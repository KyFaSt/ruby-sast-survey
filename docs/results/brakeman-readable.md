# Brakeman Security Analysis Report
Generated: 2025-09-11 14:47:48
Project: Ruby SAST Survey
Brakeman Version: 7.1.0
Rails Version: 8.0.2.1
Total Security Warnings: 12

## Summary by Vulnerability Type
- Command Injection: 6 findings
- Dangerous Eval: 1 findings
- Mass Assignment: 1 findings
- Redirect: 1 findings
- SQL Injection: 3 findings

## Summary by Confidence Level
- High: 2 findings
- Medium: 8 findings
- Weak: 2 findings

## Detailed Findings

### Finding 1: SQL Injection
**File:** `controllers/users_controller.rb`
**Line:** 8
**Confidence:** Medium
**Message:** Possible SQL injection
**Code:** `User.where("name LIKE '%#{params[:q]}%'")`
**User Input:** `params[:q]`
**Documentation:** https://brakemanscanner.org/docs/warning_types/sql_injection/

---

### Finding 2: Command Injection
**File:** `controllers/payments_controller.rb`
**Line:** 12
**Confidence:** Medium
**Message:** Possible command injection
**Code:** `system("charge --token=#{input}")`
**User Input:** `input`
**Documentation:** https://brakemanscanner.org/docs/warning_types/command_injection/

---

### Finding 3: Redirect
**File:** `controllers/users_controller.rb`
**Line:** 12
**Confidence:** High
**Message:** Possible unprotected redirect
**Code:** `redirect_to(params[:return_url])`
**User Input:** `params[:return_url]`
**Documentation:** https://brakemanscanner.org/docs/warning_types/redirect/

---

### Finding 4: SQL Injection
**File:** `models/user.rb`
**Line:** 43
**Confidence:** Weak
**Message:** Possible SQL injection
**Code:** `User.find_by_sql("SELECT * FROM users WHERE name LIKE '#{name_pattern}'")`
**User Input:** `name_pattern`
**Documentation:** https://brakemanscanner.org/docs/warning_types/sql_injection/

---

### Finding 5: Command Injection
**File:** `app.rb`
**Line:** 19
**Confidence:** Medium
**Message:** Possible command injection
**Code:** ``ls -la #{dir}``
**User Input:** `dir`
**Documentation:** https://brakemanscanner.org/docs/warning_types/command_injection/

---

### Finding 6: SQL Injection
**File:** `controllers/users_controller.rb`
**Line:** 24
**Confidence:** Medium
**Message:** Possible SQL injection
**Code:** `User.where("role = 'admin' AND name LIKE '%#{params[:q].upcase.strip}%'")`
**User Input:** `params[:q].upcase`
**Documentation:** https://brakemanscanner.org/docs/warning_types/sql_injection/

---

### Finding 7: Command Injection
**File:** `app.rb`
**Line:** 44
**Confidence:** Medium
**Message:** Possible command injection
**Code:** ``ping -c 1 #{host}``
**User Input:** `host`
**Documentation:** https://brakemanscanner.org/docs/warning_types/command_injection/

---

### Finding 8: Command Injection
**File:** `models/user.rb`
**Line:** 31
**Confidence:** Medium
**Message:** Possible command injection
**Code:** `system("backup_script.sh #{self.id}")`
**User Input:** `self.id`
**Documentation:** https://brakemanscanner.org/docs/warning_types/command_injection/

---

### Finding 9: Dangerous Eval
**File:** `models/user.rb`
**Line:** 8
**Confidence:** Weak
**Message:** Dynamic code evaluation
**Code:** `eval(formula)`
**Documentation:** https://brakemanscanner.org/docs/warning_types/dangerous_eval/

---

### Finding 10: Command Injection
**File:** `app.rb`
**Line:** 11
**Confidence:** Medium
**Message:** Possible command injection
**Code:** ``ping -c 1 #{host}``
**User Input:** `host`
**Documentation:** https://brakemanscanner.org/docs/warning_types/command_injection/

---

### Finding 11: Command Injection
**File:** `app.rb`
**Line:** 15
**Confidence:** Medium
**Message:** Possible command injection
**Code:** ``df -h #{path}``
**User Input:** `path`
**Documentation:** https://brakemanscanner.org/docs/warning_types/command_injection/

---

### Finding 12: Mass Assignment
**File:** `controllers/users_controller.rb`
**Line:** 30
**Confidence:** High
**Message:** Potentially dangerous key allowed for mass assignment
**Code:** `params.require(:user).permit(:name, :email, :admin)`
**User Input:** `:admin`
**Documentation:** https://brakemanscanner.org/docs/warning_types/mass_assignment/

---

