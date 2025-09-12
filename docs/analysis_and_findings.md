# Ruby SAST Survey - Analysis and Findings

*Comprehensive analysis of 7 Static Application Security Testing tools on intentionally vulnerable Ruby code*

---

## Key Vulnerability Types Found
- SQL Injection (multiple tools)
- Command Injection (multiple tools)
- Cross-Site Scripting (XSS)
- Mass Assignment
- Path Traversal
- Open Redirect
- Code Injection (including send() vulnerability)
- Regular Expression DoS (ReDoS)
- Insecure Deserialization
- Style and Quality Issues

## Special Finding: send() Vulnerability
### Unique Findings by Tool

#### Only CodeQL Detected
- **SystemUtilities `send()` Vulnerability**: Advanced metaprogramming vulnerability where user-controlled method names can invoke arbitrary Ruby methods
  - Attack: `params[:action] = "system"` + `params[:arg] = "rm -rf /"`
  - Result: Complete system compromise
  - Why others missed: Requires understanding of Ruby method dispatch semantics

## Cross-File Taint Tracking Analysis

**only CodeQL** successfully detected cross-file taint tracking vulnerabilities. We implemented controller methods that pass user input (`params[:formula]`, `params[:pattern]`, `params[:filename]`) to vulnerable model methods across file boundaries:

- **CodeQL**: ✅ Successfully traces data flow from `controllers/users_controller.rb` → `models/user.rb`
- **OpenGrep (Community Rules)**: ❌ Found 14 vulnerabilities but missed all cross-file taint flows
- **All other tools**: ❌ Failed to detect cross-file vulnerabilities

OpenGrep's community rules (156 rules tested) detected various vulnerability patterns within individual files but could not trace data flow across file boundaries. This demonstrates CodeQL's advanced semantic analysis capabilities for detecting complex data flow patterns that span multiple files.

---

## Tool Strengths & Weaknesses

### **Brakeman - Rails Security Specialist**
```yaml
Strengths:
  - Rails-framework aware
  - Zero false positives in test
  - Excellent vulnerability descriptions
  - Fast execution (<3 seconds)

Weaknesses:
  - Rails-only (limited for other Ruby apps)
  - No code quality checks
  - Fixed rule set (not customizable)

Best For: "Production Rails applications"
```

### **DevSkim - Microsoft Security Linter**
```yaml
Strengths:
  - Highest finding count (93 issues)
  - Multi-language support
  - SARIF output for CI/CD
  - Catches hardcoded secrets

Weaknesses:
  - Many false positives
  - Complex .NET installation
  - No Ruby-specific context
  - Noisy output

Best For: "Multi-language codebases with CI/CD integration"
```

### **CodeQL - GitHub's Semantic Engine**
```yaml
Strengths:
  - Deep semantic analysis
  - High-confidence findings
  - Excellent path tracking
  - Enterprise-grade accuracy

Weaknesses:
  - Complex setup and learning curve
  - Slow execution (>30 seconds)
  - Resource intensive
  - Query language required for custom rules

Best For: "Enterprise security audits and GitHub integration"
```

### **AST-grep - Structural Pattern Matching**
```yaml
Strengths:
  - Fast and lightweight
  - Powerful AST-based rules
  - Custom rule creation
  - Good injection detection

Weaknesses:
  - Requires AST knowledge
  - Limited built-in rules
  - No framework awareness
  - Manual rule maintenance

Best For: "Custom security patterns and team-specific rules"
```

### **Opengrep - Pattern-Based Security Scanner**
```yaml
Strengths:
  - Easy rule syntax (YAML-based)
  - Fast execution
  - Good community rule library
  - Multi-language support

Weaknesses:
  - Limited built-in Ruby rules
  - Requires rule customization
  - No framework-specific knowledge
  - May miss complex patterns

Best For: "Teams wanting customizable security rules with simple syntax"
```

### **RuboCop - Ruby Code Quality**
```yaml
Strengths:
  - Comprehensive code quality checks
  - Extensive configuration options
  - Large ecosystem of plugins
  - Excellent Rails integration

Weaknesses:
  - Limited security focus
  - Can be noisy by default
  - No vulnerability detection
  - Style-focused rather than security

Best For: "Code quality, style consistency, and maintainability"
```

### **Sorbet - Type Checking**
```yaml
Strengths:
  - Advanced type checking
  - Gradual typing approach
  - Excellent IDE integration
  - Catches type-related bugs

Weaknesses:
  - No security vulnerability detection
  - Requires type annotations
  - Learning curve for teams
  - Not focused on security

Best For: "Large codebases needing type safety and refactoring confidence"
```

---

## Performance Metrics

### **Execution Speed**
```bash
Brakeman    │ ~3s    │ Fastest
RuboCop     │ ~3s    │ Fast  
AST-grep    │ ~2s    │ Very Fast
Opengrep    │ ~5s    │ Moderate
Sorbet      │ ~8s    │ Slow
DevSkim     │ ~15s   │ Slower
CodeQL      │ ~35s   │ Slowest
```

### **Setup Complexity**
```bash
RuboCop     │ gem install                              │ Trivial
Brakeman    │ gem install                              │ Trivial  
Sorbet      │ gem install                              │ Trivial
AST-grep    │ brew install                             │ Easy
Opengrep    │ curl install script                      │ Easy
CodeQL      │ brew + pack download                     │ Moderate
DevSkim     │ .NET SDK + dotnet tool                   │ Complex
```

---

## Vulnerability Complexity Analysis

### **SQL Injection Detection**
```diff
+ Brakeman     ✅ Detected 3 variants
+ AST-grep     ✅ Detected 3 variants  
+ CodeQL       ✅ Detected 3 variants
+ OpenGrep     ✅ Detected 2 variants
- DevSkim      ❌ Not detected
- RuboCop      ❌ Not detected
- Sorbet       ❌ Not detected
```

### **Command Injection Detection**
```diff
+ Brakeman     ✅ Detected 6 variants
+ AST-grep     ✅ Detected 2 variants
+ OpenGrep     ✅ Detected 5 variants
+ CodeQL       ✅ Detected 2 variants
- DevSkim      ❌ Not detected
- RuboCop      ❌ Not detected
- Sorbet       ❌ Not detected
```

### **Mass Assignment Detection**
```diff
+ Brakeman     ✅ Detected with context
+ Opengrep     ✅ Detected 1 variant
- Others       ❌ Not detected
```

### **Path Traversal Detection**
```diff
+ CodeQL       ✅ Detected with data flow
+ OpenGrep     ✅ Detected 1 variant
- Others       ❌ Not detected
```

### **Code Injection (eval/send) Detection**
```diff
+ CodeQL       ✅ Detected send() vulnerability (ONLY tool)
+ Brakeman     ✅ Detected eval usage
- Others       ❌ send() vulnerability not detected
```

### **Cross-Site Scripting (XSS) Detection**
```diff
+ OpenGrep     ✅ Detected 3 XSS vulnerabilities
- Others       ❌ Not detected
```

### **Open Redirect Detection**
```diff
+ Brakeman     ✅ Detected redirect vulnerability
+ CodeQL       ✅ Detected redirect vulnerability
+ OpenGrep     ✅ Detected redirect vulnerability
- Others       ❌ Not detected
```

---

## Vulnerability Breakdown

### **Total Findings by Tool**
| Tool | Total Findings | Security Issues | Code Quality | Type Issues |
|------|----------------|-----------------|--------------|-------------|
| **DevSkim** | `93` | High | Medium | None |
| **RuboCop** | `28` | Medium | High | None |
| **OpenGrep** | `13` | High | None | None |
| **Brakeman** | `12` | High | None | None |
| **CodeQL** | `10` | High | None | None |
| **AST-grep** | `5` | High | None | None |
| **Sorbet** | `Manual` | None | Medium | High |

### **Critical Security Issues Found**

```ruby
# SQL Injection (Found by: Brakeman, CodeQL, AST-grep, OpenGrep)
result = db.execute("SELECT * FROM users WHERE id = #{params[:id]}")
#                                                   ^^^^^^^^^^^^
#                                              Unescaped user input

# Command Injection (Found by: Brakeman, AST-grep, OpenGrep, CodeQL)  
result = `ping -c 1 #{host}`
#                   ^^^^^^
#               User-controlled system command

# send() Method Injection (Found by: CodeQL ONLY)
util.send(method, argument)
#         ^^^^^^
#    User-controlled method name - CRITICAL

# Path Traversal (Found by: CodeQL, OpenGrep)
file_path = "uploads/#{params[:name]}"
#                     ^^^^^^^^^^^^^
#                 Unvalidated file path

# Mass Assignment (Found by: Brakeman, Opengrep)
params.require(:user).permit(:name, :email, :admin)
#                                           ^^^^^^
#                                      Dangerous field
```

### **Vulnerability Types by Detection Rate**
- **Command Injection:** 4/7 tools (Brakeman, AST-grep, OpenGrep, CodeQL)
- **SQL Injection:** 4/7 tools (Brakeman, CodeQL, AST-grep, OpenGrep)
- **Cross-Site Scripting (XSS):** 1/7 tools (OpenGrep)
- **Open Redirect:** 3/7 tools (Brakeman, CodeQL, OpenGrep)
- **Mass Assignment:** 2/7 tools (Brakeman, OpenGrep)
- **Path Traversal:** 2/7 tools (CodeQL, OpenGrep)
- **Code Injection (eval):** 1/7 tools (Brakeman)
- **send() Vulnerability:** 1/7 tools (CodeQL ONLY)

---

## Key Insights

### **Winner by Category**

| Category | Tool | Reason |
|----------|------|--------|
| **Security Detection** | `Brakeman` | Rails expertise + comprehensive coverage |
| **Code Quality** | `RuboCop` | Comprehensive style and best practices |
| **Type Safety** | `Sorbet` | Advanced type checking capabilities |
| **Enterprise Security** | `CodeQL` | Deep semantic analysis + send() detection |
| **Multi-Language** | `DevSkim` | Broad language support |
| **Custom Rules** | `AST-grep` | Powerful pattern matching |
| **Community Rules** | `OpenGrep` | Excellent rule library |

### **Optimal Tool Combination**
```bash
# The "Security Trifecta" for Ruby/Rails
1. Brakeman     → Rails-specific security (12 findings)
2. CodeQL       → Deep semantic analysis (10 findings, ONLY send() detection)
3. RuboCop      → Code quality + basic security (28 findings)

# Additional tools for specific needs:
+ OpenGrep      → Community security rules (13 findings)
+ AST-grep      → Custom security patterns (5 findings)
+ DevSkim       → Multi-language environments (93 findings, high noise)
+ Sorbet        → Type safety
```

### **Detection Coverage Summary**
- **Total unique vulnerabilities found:** 161 across all tools
- **Most comprehensive coverage:** Brakeman (Rails-focused) + CodeQL (advanced analysis)
- **Highest volume:** DevSkim (93 findings, many false positives)
- **Best precision:** Brakeman and CodeQL (low false positive rates)
- **Unique advanced detection:** CodeQL's send() vulnerability (critical finding missed by all others)

---

## Conclusion

**No single tool catches everything** - layered security scanning provides the best coverage:

- **Brakeman** excels at Rails-specific vulnerabilities (12 critical findings)
- **CodeQL** provides enterprise-grade semantic analysis (ONLY tool to detect send() vulnerability)
- **OpenGrep** offers excellent community-driven security rules (13 findings)
- **RuboCop** ensures code quality and maintainability (28 quality findings)
- **AST-grep** enables custom security patterns (5 targeted findings)
- **DevSkim** provides broad pattern coverage with significant noise (93 findings)

**Critical Insight:** The sophisticated send() method injection vulnerability was **ONLY** detected by CodeQL, demonstrating the value of advanced static analysis for Ruby metaprogramming patterns.

**Recommendation:** Start with Brakeman, RuboCop in a quick feedback loop, if possible.
Brakeman may need to run in CI/CD.  Run a more intensive tool (CodeQL, Opengrep) in CI/CD, ideally on PR as developers seem to be more likely to fix at that stage than later.
