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

## 5. Common Vulnerabilities in Ruby

**Code Samples:**

### SQL Injection
```ruby
# Vulnerable
User.where("name = '#{params[:name]}'")

# Safe
User.where(name: params[:name])
```

### Command Injection
```ruby
# Vulnerable
system("ls #{params[:dir]}")

# Safe
system("ls", params[:dir])
```

### XSS
```ruby
# Vulnerable
"<h1>Hello #{params[:name]}!</h1>".html_safe

# Safe
content_tag(:h1, "Hello #{params[:name]}!")
```

### Mass Assignment
```ruby
# Vulnerable
User.new(params[:user])

# Safe
User.new(params.require(:user).permit(:name, :email))
```

**Notes:**
- Focus on Ruby-specific patterns
- Show both vulnerable and safe alternatives

---

## 6. Challenges in Ruby

**Notes:**
- Dynamic typing makes static analysis harder
- Metaprogramming obscures code paths
- Framework magic (Rails) hides complexity
- Duck typing assumptions
- String interpolation prevalence

**Example:**
```ruby
# Hard for static analysis to understand
class DynamicModel
  params.each do |key, value|
    define_method(key) { value }
  end
end
```

---

## 7. Section Slide - How SAST Works

**Notes:**
- Three main approaches overview
- Each has trade-offs between speed and accuracy

---

## 8. How SAST Works - Three Approaches

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

## 9. How Regex Works - Visual Example

**Pattern:**
```regex
eval\s*\(\s*.*params
```

**Code Example:**
```ruby
# This gets flagged
eval(params[:code])

# This also gets flagged (false positive)
# eval("safe_constant")  # Safe but flagged

# This gets missed (false negative)  
dangerous_method = "eval"
send(dangerous_method, params[:code])
```

**Notes:**
- Show regex pattern matching
- Highlight false positives and negatives
- Visual diagram of pattern matching

---

## 10. How AST Works - Visual Example

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

## 11. How Data Flow Tracking Works - Visual Example

**Code:**
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

**Notes:**
- Show taint flow visualization
- Explain source, sink, and sanitization concepts
- Most accurate approach

---

## 12. Section Slide - SAST Landscape

**Notes:**
- Overview of available tools for Ruby
- Categorize by familiarity level

---

## 13. Tools Rubyists May Already Be Familiar With

### Sorbet - Type Checking
```ruby
# typed: strict
extend T::Sig

sig { params(name: String).returns(String) }
def greet(name)
  "Hello #{name}"
end
```

### RuboCop - Code Quality
```ruby
# Detects security issues
Security/Eval
Security/YAMLLoad
Security/Open
```

### Brakeman - Rails Security
```ruby
# Specialized for Rails vulnerabilities
# Understands Rails idioms and patterns
```

**Notes:**
- Tools developers likely know
- Their security capabilities
- Integration into existing workflows

---

## 14. Tools Rubyists May Be Less Familiar With

### OpenGrep/Semgrep
```yaml
rules:
  - id: sql-injection
    pattern: |
      $MODEL.where("... #{$VAR} ...")
    message: Potential SQL injection
    languages: [ruby]
    severity: ERROR
```

### DevSkim
**Notes:**
- Microsoft security linter
- Cross-language support
- Pattern-based detection

### AST-grep
```yaml
rule:
  pattern: |
    $MODEL.where("... #{$VAR} ...")
  message: Potential SQL injection vulnerability detected
```

### CodeQL
**Notes:**
- GitHub's semantic analysis engine
- Enterprise-grade precision
- Complex query language

---

## 15. Section Slide - Detection

**Notes:**
- Live demonstration of vulnerable code
- Show each tool's output

---

## 16. Vulnerable Code

**Example from controllers/users_controller.rb:**
```ruby
def search
  # Step 1: User input enters the system
  search_term = T.cast(params[:q], String)     # 🚨 Taint source
  
  # Step 2: Data transformations (developers think this "sanitizes")
  processed_term = search_term.upcase          # 🔄 Still tainted
  sanitized_term = processed_term.strip        # 🔄 Still tainted
  
  # Step 3: Tainted data reaches dangerous sink
  @admins = User.where("role = 'admin' AND name LIKE '%#{sanitized_term}%'")
  #                                                   ^^^^^^^^^^^^^^
  #                                               🎯 SQL injection here!
end
```

**Attack Vector:** `GET /search?q='; DROP TABLE users; --`

**Notes:**
- Real-world example
- Common developer misconception
- Multiple transformation steps

---

## 17. Sorbet Detection

**Output:**
```
No security-related errors found.
Type checking focuses on type safety, not security vulnerabilities.
```

**Notes:**
- Type checker, not security tool
- Catches type-related issues only
- Complementary to security tools

---

## 18. RuboCop Detection

**Output:**
```ruby
controllers/users_controller.rb:29:32: C: Security/Eval: The use of eval is a serious security risk.
controllers/users_controller.rb:26:15: C: Security/YAMLLoad: Prefer using YAML.safe_load over YAML.load.
```

**Notes:**
- Good at catching dangerous methods
- Limited data flow analysis
- Fast execution

---

## 19. Brakeman Detection

**Output:**
```json
{
  "check_name": "SQL",
  "message": "Possible SQL injection",
  "file": "controllers/users_controller.rb", 
  "line": 29,
  "confidence": "Medium"
}
```

**Notes:**
- Excellent Rails vulnerability detection
- Understands data flow through transformations
- Framework-aware analysis

---

## 20. DevSkim Detection

**Output:**
```
❌ 0/4 vulnerabilities detected in controllers/users_controller.rb
❌ High false positive rate in other files (flags tool outputs as "secrets")
```

**Notes:**
- Pattern-based only
- No understanding of Ruby/Rails idioms
- High noise-to-signal ratio

---

## 21. OpenGrep Detection

**Community Rules Output:**
```json
{
  "check_id": "ruby.rails.security.injection.tainted-sql-string.tainted-sql-string",
  "path": "controllers/users_controller.rb",
  "start": {"line": 29},
  "message": "SQL query built from user-controlled sources",
  "dataflow_trace": {
    "taint_source": ["params"],
    "intermediate_vars": ["search_term", "processed_term", "sanitized_term"],
    "taint_sink": ["User.where"]
  }
}
```

**Notes:**
- Excellent with community rules
- Sophisticated taint tracking
- Rule quality matters

---

## 22. AST-grep Detection

**Output:**
```
error[sql-injection]: Potential SQL injection vulnerability detected
   ┌─ controllers/users_controller.rb:29:21
   │
29 │     User.where("role = 'admin' AND name LIKE '%#{sanitized_term}%'")
   │                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
```

**Notes:**
- Fast structural pattern matching
- No data flow analysis
- Good for specific patterns

---

## 23. CodeQL Detection

**Output:**
```json
{
  "ruleId": "rb/sql-injection",
  "message": "This SQL query depends on a [user-provided value](1).",
  "locations": [{
    "physicalLocation": {
      "artifactLocation": {"uri": "controllers/users_controller.rb"},
      "region": {"startLine": 29}
    }
  }]
}
```

**Notes:**
- High precision semantic analysis
- Excellent taint tracking
- Slow execution time

---

## 24. What Each Tool Sees or Misses

| Tool | SQL Injection | Data Flow | False Positives | Speed |
|------|---------------|-----------|-----------------|-------|
| **Brakeman** | ✅ Excellent | ✅ Yes | 🟢 Low | 🟢 Fast |
| **OpenGrep (auto)** | ✅ Excellent | ✅ Yes | 🟡 Medium | 🟡 Medium |
| **CodeQL** | ✅ Excellent | ✅ Yes | 🟢 Low | 🔴 Slow |
| **AST-grep** | ✅ Pattern only | ❌ No | 🟢 Low | 🟢 Fast |
| **RuboCop** | ⚠️ Limited | ❌ No | 🟢 Low | 🟢 Fast |
| **DevSkim** | ❌ Poor | ❌ No | 🔴 High | 🟢 Fast |
| **Sorbet** | ❌ Not security | ❌ No | 🟢 Low | 🟡 Medium |

**Notes:**
- Clear winner for Rails: Brakeman
- Community rules matter: OpenGrep
- Precision vs Speed trade-offs

---

## 25. Section Slide - Pragmatic Implementation

**Notes:**
- Real-world constraints and considerations
- Making informed tool choices

---

## 26. Practical Limitations

### Performance Impact
- CodeQL: 30+ seconds for small projects
- Brakeman: 1-3 seconds
- RuboCop: 2-5 seconds

### False Positive Management
- DevSkim: ~70% false positive rate
- OpenGrep: Depends on rule quality
- Brakeman: <5% false positive rate

### Learning Curve
- Simple: RuboCop, Brakeman
- Medium: OpenGrep, AST-grep
- Complex: CodeQL

### Maintenance Overhead
- Custom rules require ongoing updates
- Community rules need evaluation
- Tool updates may break workflows

**Notes:**
- Be realistic about constraints
- Consider team capabilities
- Plan for maintenance

---

## 27. Performance Comparison

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
- CodeQL best for comprehensive analysis, not CI/CD
- Most tools suitable for continuous integration

---

## 28. Where to Integrate

| Stage | Recommended Tools | Purpose |
|-------|------------------|---------|
| **IDE/Editor** | RuboCop, Sorbet | Real-time feedback |
| **Pre-commit Hook** | Brakeman, RuboCop | Quick security check |
| **CI/CD Pipeline** | Brakeman, OpenGrep, AST-grep | Automated security testing |
| **Scheduled Deep Scan** | CodeQL, Full OpenGrep suite | Comprehensive analysis |
| **Security Review** | All tools + manual review | Complete assessment |

**Implementation Strategy:**
1. Start with Brakeman (Rails-specific)
2. Add RuboCop for code quality + security cops
3. Integrate OpenGrep for custom patterns
4. Consider CodeQL for enterprise/compliance

**Notes:**
- Layered approach works best
- Different tools for different stages
- Balance security and developer experience

---

## 29. Resources and Next Steps

### Getting Started
1. **Rails projects**: Start with Brakeman
2. **Non-Rails Ruby**: Begin with RuboCop security cops
3. **Custom patterns**: Explore AST-grep or OpenGrep
4. **Enterprise**: Evaluate CodeQL

### Learning Resources
- **Brakeman**: https://brakemanscanner.org/
- **OpenGrep**: https://opengrep.dev/
- **CodeQL**: https://codeql.github.com/
- **OWASP Ruby Security**: https://owasp.org/www-project-ruby-on-rails-security-guide/

### Community
- Ruby Security Working Group
- SAST tool-specific communities
- Security-focused Ruby conferences

### Action Items
- [ ] Audit current security tooling
- [ ] Implement basic SAST in CI/CD
- [ ] Train team on security patterns
- [ ] Establish security review process

**Notes:**
- Provide concrete next steps
- Resources for continued learning
- Community engagement opportunities

---

## Appendix: Tool Installation Commands

### Quick Setup
```bash
# Brakeman
gem install brakeman

# RuboCop with security
gem install rubocop rubocop-rails

# OpenGrep
pip install opengrep

# AST-grep
brew install ast-grep

# CodeQL
brew install codeql

# DevSkim
dotnet tool install --global Microsoft.CST.DevSkim.CLI
```

### Example CI/CD Integration
```yaml
# .github/workflows/security.yml
name: Security Scan
on: [push, pull_request]
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Brakeman
        run: |
          gem install brakeman
          brakeman --format sarif --output brakeman.sarif
      - name: Upload to GitHub Security
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: brakeman.sarif
```

**Notes:**
- Ready-to-use setup commands
- Example CI/CD configuration
- GitHub Security tab integration