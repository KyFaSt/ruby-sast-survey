# OpenGrep Security Analysis Report
Generated: 2025-09-11 14:47:48
Project: Ruby SAST Survey
OpenGrep Version: 1.10.0
Total Findings: 13

## Summary by Severity
- ERROR: 3 findings
- WARNING: 10 findings

## Summary by Check Type
- ruby.lang.security.dangerous-exec.dangerous-exec: 1 findings
- ruby.lang.security.dangerous-subshell.dangerous-subshell: 4 findings
- ruby.lang.security.model-attr-accessible.model-attr-accessible: 1 findings
- ruby.rails.security.audit.avoid-tainted-file-access.avoid-tainted-file-access: 1 findings
- ruby.rails.security.audit.xss.avoid-redirect.avoid-redirect: 1 findings
- ruby.rails.security.injection.raw-html-format.raw-html-format: 3 findings
- ruby.rails.security.injection.tainted-sql-string.tainted-sql-string: 2 findings

## Detailed Findings

### Finding 1: ruby.lang.security.dangerous-subshell.dangerous-subshell
**File:** `app.rb`
**Line:** 11
**Severity:** WARNING
**Message:** Detected non-static command inside `...`. If unverified user data can reach this call site, this is a code injection vulnerability. A malicious actor can inject a malicious script to execute arbitrary code.
**Code:** ``ping -c 1 #{host}``
**CWE:** ["CWE-94: Improper Control of Generation of Code ('Code Injection')"]

---

### Finding 2: ruby.lang.security.dangerous-subshell.dangerous-subshell
**File:** `app.rb`
**Line:** 15
**Severity:** WARNING
**Message:** Detected non-static command inside `...`. If unverified user data can reach this call site, this is a code injection vulnerability. A malicious actor can inject a malicious script to execute arbitrary code.
**Code:** ``df -h #{path}``
**CWE:** ["CWE-94: Improper Control of Generation of Code ('Code Injection')"]

---

### Finding 3: ruby.lang.security.dangerous-subshell.dangerous-subshell
**File:** `app.rb`
**Line:** 19
**Severity:** WARNING
**Message:** Detected non-static command inside `...`. If unverified user data can reach this call site, this is a code injection vulnerability. A malicious actor can inject a malicious script to execute arbitrary code.
**Code:** ``ls -la #{dir}``
**CWE:** ["CWE-94: Improper Control of Generation of Code ('Code Injection')"]

---

### Finding 4: ruby.rails.security.injection.raw-html-format.raw-html-format
**File:** `app.rb`
**Line:** 37
**Severity:** WARNING
**Message:** Detected user input flowing into a manually constructed HTML string. You may be accidentally bypassing secure methods of rendering HTML by manually constructing HTML and this could create a cross-site scripting vulnerability, which could let attackers steal sensitive user data. Use the `render template` and make template files which will safely render HTML instead, or inspect that the HTML is absolutely rendered safely with a function like `sanitize`.
**Code:** `"<h1>Search results for: #{query}</h1>"`
**CWE:** ["CWE-79: Improper Neutralization of Input During Web Page Generation ('Cross-site Scripting')"]

---

### Finding 5: ruby.lang.security.dangerous-subshell.dangerous-subshell
**File:** `app.rb`
**Line:** 44
**Severity:** WARNING
**Message:** Detected non-static command inside `...`. If unverified user data can reach this call site, this is a code injection vulnerability. A malicious actor can inject a malicious script to execute arbitrary code.
**Code:** `result = `ping -c 1 #{host}``
**CWE:** ["CWE-94: Improper Control of Generation of Code ('Code Injection')"]

---

### Finding 6: ruby.rails.security.injection.raw-html-format.raw-html-format
**File:** `app.rb`
**Line:** 45
**Severity:** WARNING
**Message:** Detected user input flowing into a manually constructed HTML string. You may be accidentally bypassing secure methods of rendering HTML by manually constructing HTML and this could create a cross-site scripting vulnerability, which could let attackers steal sensitive user data. Use the `render template` and make template files which will safely render HTML instead, or inspect that the HTML is absolutely rendered safely with a function like `sanitize`.
**Code:** `"<pre>#{result}</pre>"`
**CWE:** ["CWE-79: Improper Neutralization of Input During Web Page Generation ('Cross-site Scripting')"]

---

### Finding 7: ruby.rails.security.audit.avoid-tainted-file-access.avoid-tainted-file-access
**File:** `app.rb`
**Line:** 52
**Severity:** WARNING
**Message:** Using user input when accessing files is potentially dangerous. A malicious actor could use this to modify or access files they have no right to.
**Code:** `File.read("files/#{filename}")`
**CWE:** ["CWE-22: Improper Limitation of a Pathname to a Restricted Directory ('Path Traversal')"]

---

### Finding 8: ruby.rails.security.injection.raw-html-format.raw-html-format
**File:** `app.rb`
**Line:** 63
**Severity:** WARNING
**Message:** Detected user input flowing into a manually constructed HTML string. You may be accidentally bypassing secure methods of rendering HTML by manually constructing HTML and this could create a cross-site scripting vulnerability, which could let attackers steal sensitive user data. Use the `render template` and make template files which will safely render HTML instead, or inspect that the HTML is absolutely rendered safely with a function like `sanitize`.
**Code:** `"<pre>#{result}</pre>"`
**CWE:** ["CWE-79: Improper Neutralization of Input During Web Page Generation ('Cross-site Scripting')"]

---

### Finding 9: ruby.lang.security.dangerous-exec.dangerous-exec
**File:** `controllers/payments_controller.rb`
**Line:** 12
**Severity:** WARNING
**Message:** Detected non-static command inside system. Audit the input to 'system'. If unverified user data can reach this call site, this is a code injection vulnerability. A malicious actor can inject a malicious script to execute arbitrary code.
**Code:** `system(command) # 🚨 Potential command injection`
**CWE:** ["CWE-94: Improper Control of Generation of Code ('Code Injection')"]

---

### Finding 10: ruby.rails.security.injection.tainted-sql-string.tainted-sql-string
**File:** `controllers/users_controller.rb`
**Line:** 8
**Severity:** ERROR
**Message:** Detected user input used to manually construct a SQL string. This is usually bad practice because manual construction could accidentally result in a SQL injection. An attacker could use a SQL injection to steal or modify contents of the database. Instead, use a parameterized query which is available by default in most database engines. Alternatively, consider using an object-relational mapper (ORM) such as ActiveRecord which will protect your queries.
**Code:** `@users = User.where("name LIKE '%#{params[:q]}%'")`
**CWE:** ["CWE-89: Improper Neutralization of Special Elements used in an SQL Command ('SQL Injection')"]

---

### Finding 11: ruby.rails.security.audit.xss.avoid-redirect.avoid-redirect
**File:** `controllers/users_controller.rb`
**Line:** 12
**Severity:** WARNING
**Message:** When a redirect uses user input, a malicious user can spoof a website under a trusted URL or access restricted parts of a site. When using user-supplied values, sanitize the value before using it for the redirect.
**Code:** `redirect_to params[:return_url]`
**CWE:** ["CWE-601: URL Redirection to Untrusted Site ('Open Redirect')"]

---

### Finding 12: ruby.rails.security.injection.tainted-sql-string.tainted-sql-string
**File:** `controllers/users_controller.rb`
**Line:** 24
**Severity:** ERROR
**Message:** Detected user input used to manually construct a SQL string. This is usually bad practice because manual construction could accidentally result in a SQL injection. An attacker could use a SQL injection to steal or modify contents of the database. Instead, use a parameterized query which is available by default in most database engines. Alternatively, consider using an object-relational mapper (ORM) such as ActiveRecord which will protect your queries.
**Code:** `@admins = User.where("role = 'admin' AND name LIKE '%#{sanitized_term}%'")`
**CWE:** ["CWE-89: Improper Neutralization of Special Elements used in an SQL Command ('SQL Injection')"]

---

### Finding 13: ruby.lang.security.model-attr-accessible.model-attr-accessible
**File:** `controllers/users_controller.rb`
**Line:** 30
**Severity:** ERROR
**Message:** Checks for dangerous permitted attributes that can lead to mass assignment vulnerabilities. Query parameters allowed using permit and attr_accessible are checked for allowance of dangerous attributes admin, banned, role, and account_id. Also checks for usages of params.permit!, which allows everything. Fix: don't allow admin, banned, role, and account_id using permit or attr_accessible.
**Code:** `params.require(:user).permit(:name, :email, :admin)`
**CWE:** ["CWE-915: Improperly Controlled Modification of Dynamically-Determined Object Attributes"]

---

