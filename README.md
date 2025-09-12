# Ruby SAST Tool Survey

A comprehensive comparison of Static Application Security Testing (SAST) tools for Ruby applications, featuring intentionally vulnerable code examples to test detection capabilities.

## Project Structure

```
ruby-sast-survey/
├── README.md
├── Gemfile
├── Gemfile.lock
├── app.rb                      # Main Sinatra application
├── controllers/
│   ├── application_controller.rb
│   └── users_controller.rb
├── models/
│   ├── application_record.rb
│   └── user.rb
├── .github/
│   └── workflows/
│       ├── brakeman.yml
│       ├── rubocop.yml
│       ├── opengrep.yml
│       ├── ast-grep.yml
│       ├── devskim.yml
│       └── codeql.yml
├── .githooks/                  # Optional git hooks for fast security checks
│   ├── pre-push               # RuboCop, Brakeman before push
│   └── commit-msg             # Quick security pattern checks
├── ast-grep-rules/
│   ├── sql-injection.yml
│   └── command-injection.yml
├── docs/
│   ├── results/              # Tool output files
│   └── tool-comparison.md
├── sorbet/                   # Sorbet configuration
├── .rubocop.yml
├── .brakeman.yml
├── sgconfig.yml              # ast-grep project config
├── opengrep.yml
├── codeql-config.yml
└── devskim.json
```

## Vulnerable Code Examples

The application contains intentionally vulnerable Ruby code to test SAST tool detection:

- **SQL Injection**: String interpolation in database queries (`app.rb`, `controllers/users_controller.rb`, `models/user.rb`)
- **Command Injection**: Unsafe system calls and backtick execution with user input (`app.rb`, `models/user.rb`)
- **XSS**: Unescaped output in web responses (`app.rb`)
- **Path Traversal**: Unvalidated file access (`app.rb`)
- **Mass Assignment**: Allowing admin parameter in user params (`controllers/users_controller.rb`)
- **ReDoS**: Catastrophic backtracking in regex (`models/user.rb`)
- **Open Redirect**: Unvalidated redirect_to usage (`controllers/users_controller.rb`)

## Tools Tested

### 1. Brakeman
**Focus**: Rails-specific security scanner with deep framework knowledge
**Strengths**: 
- Excellent Rails vulnerability detection (SQL injection, mass assignment, open redirects)
- Framework-aware analysis reduces false positives
- High confidence scoring system
- Zero setup for Rails projects

**Weaknesses**:
- Limited to Rails/Ruby applications
- May miss vulnerabilities in non-Rails Ruby code
- Less effective on modern Rails security features

### 2. RuboCop
**Focus**: Ruby static code analyzer with security cops enabled
**Strengths**:
- Comprehensive code quality and style analysis
- Security cops catch dangerous patterns (eval, YAML.load)
- Highly configurable with team-specific rules
- Fast execution and good IDE integration

**Weaknesses**:
- Limited security focus (primarily style/quality tool)
- No data flow analysis capabilities
- Security detection depends on specific cop configuration

### 3. Opengrep
**Focus**: Pattern-based security scanner with community and custom rules
**Strengths**:
- Excellent community rules with taint tracking capabilities
- Easy custom rule creation with YAML syntax
- Cross-language support
- Good balance of speed and accuracy with community rules

**Weaknesses**:
- Custom rules require significant maintenance
- Community rules may have occasional false positives
- Limited Ruby/Rails expertise without community rulesets

### 4. AST-grep
**Focus**: Structural search tool for finding security patterns
**Strengths**:
- Fast structural pattern matching
- Precise AST-based queries reduce false positives
- Excellent for team-specific vulnerability patterns
- Simple YAML rule syntax

**Weaknesses**:
- No built-in security knowledge or data flow analysis
- Requires custom rules for each vulnerability type
- Limited out-of-the-box security coverage

### 5. DevSkim
**Focus**: Microsoft's lightweight security linter
**Strengths**:
- Cross-language security pattern detection
- Easy integration into development workflows
- Good coverage of common security anti-patterns

**Weaknesses**:
- High false positive rate due to pattern-only matching
- Limited Ruby/Rails specific knowledge
- No understanding of framework idioms or data flow

### 6. CodeQL
**Focus**: GitHub's semantic code analysis engine
**Strengths**:
- Excellent semantic analysis with data flow tracking
- Enterprise-grade precision and low false positive rate
- Sophisticated taint tracking through complex transformations
- Comprehensive query suites for multiple languages

**Weaknesses**:
- Slow execution
- Complex setup and query development
- Limited Ruby security query coverage compared to Java/C#

### 7. Sorbet
**Focus**: Gradual type checker for Ruby
**Strengths**:
- Catches type-related bugs and logic errors
- Improves code maintainability and documentation
- Good IDE integration with type hints

**Weaknesses**:
- Not a security tool (type checking focus)
- Requires type annotations for full effectiveness
- No security vulnerability detection capabilities

## Quick Start

1. **Clone and setup**:
   ```bash
   git clone <repository>
   cd ruby-sast-survey
   bundle install
   ```

2. **Install additional tools** (first time only):
   ```bash
   # Install ast-grep
   brew install ast-grep
   
   # Install opengrep
   curl -fsSL https://raw.githubusercontent.com/opengrep/opengrep/main/install.sh | bash
   export PATH='$HOME/.opengrep/cli/latest':$PATH
   
   # Install CodeQL CLI
   brew install codeql
   
   # Download CodeQL query pack
   codeql pack download codeql/ruby-queries
   
   # Install DevSkim (requires .NET SDK)
   brew install --cask dotnet-sdk
   dotnet tool install --global Microsoft.CST.DevSkim.CLI
   export PATH="$PATH:$HOME/.dotnet/tools"
   ```

3. **Run individual tools**:
   ```bash
   # RuboCop - Ruby static code analyzer
   bundle exec rubocop --format json --out docs/results/rubocop.json
   
   # Brakeman - Rails security scanner (use --force for non-Rails apps)
   bundle exec brakeman --force --format json --output docs/results/brakeman.json
   
   # Sorbet - Type checker
   bundle exec srb typecheck 2>&1 | tee docs/results/sorbet.txt
   
   # AST-grep - Structural search
   ast-grep scan --json=pretty > docs/results/ast-grep.json
   
   # Opengrep - Pattern-based security scanner (use community rules for better coverage)
   opengrep --config auto --json --output=docs/results/opengrep.json .
   
   # Or use custom rules only (limited coverage)
   opengrep --config=opengrep.yml --json --output=docs/results/opengrep.json .
   
   # CodeQL - Semantic analysis
   codeql database create ruby-db --language=ruby --source-root=.
   codeql database analyze ruby-db codeql/ruby-queries:codeql-suites/ruby-security-and-quality.qls --format=sarif-latest --output=docs/results/codeql.sarif
   
   # DevSkim - Microsoft security linter
   devskim analyze -I . -O docs/results/devskim.sarif -f sarif
   devskim analyze -I . -O docs/results/devskim.txt -f text
   ```

   **Or run all tools with a single script**:
   ```bash
   ./run-all-tools.sh
   ```

4. **Run all tools via GitHub Actions**:
   Push to repository or create PR to trigger all workflows.

## Git Hooks for Fast Security Checks

For developers who want immediate security feedback during their workflow, this project includes pre-configured git hooks that run fast SAST tools before pushing code.

### Available Git Hooks

**Pre-Push Hook** (`.githooks/pre-push`):
- **RuboCop**: Fast Ruby static analysis with security cops
- **Brakeman**: Rails security scanner (usually completes in seconds)
- **AST-grep**: Fast structural pattern matching (if custom rules exist)

**Commit-Msg Hook** (`.githooks/commit-msg`):
- Scans commit messages for sensitive terms
- Quick checks for hardcoded secrets in staged files
- Warns about dangerous patterns like `eval()` and command injection

### Enable Git Hooks

```bash
# 1. Configure git to use the project's hooks directory
git config core.hooksPath .githooks

# 2. Edit the hook files to uncomment the tools you want to use
# All commands are commented out by default for safety

```

### Why These Tools for Git Hooks?

**✅ Recommended for Hooks:**
- **RuboCop**: Very fast (< 1 second), catches common security anti-patterns
- **Brakeman**: Fast for most codebases (< 5 seconds), high-confidence security findings
- **AST-grep**: Fast structural matching, good for team-specific patterns

**❌ Not Recommended for Hooks:**
- **CodeQL**: Too slow (1-5 minutes), better for CI/CD
- **Opengrep**: Moderate speed with community rules, can slow down commits
- **DevSkim**: High false positive rate, better for CI/CD review
- **Sorbet**: Type checking focus, not security-specific

### Hook Philosophy

The git hooks are designed to:
- **Fail Fast**: Catch obvious security issues before they reach the repository
- **Stay Fast**: Never slow down the development workflow
- **Stay Optional**: All commands are commented out by default
- **Complement CI**: Let GitHub Actions handle comprehensive scanning

For complete security coverage, rely on the GitHub Actions workflows that run all tools including the slower, more comprehensive ones.

## Testing GitHub Actions Locally with Act

This project uses [act](https://github.com/nektos/act) to test GitHub Actions workflows locally before pushing to GitHub.

### Setup Act

   ```bash
   brew install act
   ```

### Running Actions Locally

**List available workflows**:
```bash
act -l
```

**Run all workflows** (simulates push event):
```bash
act push
```

**Run specific workflow**:
```bash
# Test individual SAST tools
act -W .github/workflows/brakeman.yml
act -W .github/workflows/rubocop.yml
act -W .github/workflows/codeql.yml
act -W .github/workflows/opengrep.yml
act -W .github/workflows/ast-grep.yml
act -W .github/workflows/devskim.yml
act -W .github/workflows/sorbet.yml
```

### Act Configuration

Act uses Docker containers to simulate GitHub Actions runners. On first run, it will:
- Ask you to choose a Docker image size (recommend "Medium" for Ruby projects)
- Download the appropriate runner image
- Cache it for future runs

**Note**: Act runs are faster than GitHub Actions but may have slight differences due to the local Docker environment vs GitHub's hosted runners.

### Troubleshooting Act

**Common Issues on Apple Silicon (M1/M2) Macs:**

1. **CodeQL ARM64 Error**: CodeQL doesn't support linux/arm64. Use x86_64 containers:
   ```bash
   act --container-architecture linux/amd64
   ```

2. **Platform Lock Error**: Add Linux platforms to Gemfile.lock:
   ```bash
   bundle lock --add-platform aarch64-linux x86_64-linux
   ```

3. **Node.js Missing Error**: Use an image with Node.js:
   ```bash
   act --container-architecture linux/amd64 -P ubuntu-latest=node:18-bullseye
   ```

## Contributing

Feel free to add more vulnerable code examples or improve tool configurations!

## ⚠️ Security Notice

This repository contains intentionally vulnerable code for educational purposes. **Do not deploy this code to production environments.**
