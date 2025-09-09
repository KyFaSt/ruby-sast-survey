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
Rails-specific security scanner with deep framework knowledge.
```bash
bundle exec brakeman --force --format json --output docs/results/brakeman.json
```

### 2. RuboCop
Ruby static code analyzer with security cops enabled.
```bash
bundle exec rubocop --format json --out docs/results/rubocop.json
```

### 3. Opengrep (Semgrep)
Pattern-based security scanner with custom rules.
```bash
opengrep --config=opengrep.yml --json --output=docs/results/opengrep.json .
```

### 4. AST-grep
Structural search tool for finding security patterns.
```bash
# Run with JSON output
ast-grep scan --json=pretty > docs/results/ast-grep.json

# Run with default output
ast-grep scan
```

### 5. DevSkim
Microsoft's lightweight security linter.
```bash
# Install (requires .NET SDK)
brew install --cask dotnet-sdk
dotnet tool install --global Microsoft.CST.DevSkim.CLI
export PATH="$PATH:$HOME/.dotnet/tools"

# Run analysis
devskim analyze -I . -O docs/results/devskim.sarif -f sarif
devskim analyze -I . -O docs/results/devskim.txt -f text
```

### 6. CodeQL
GitHub's semantic code analysis engine.
```bash
# Create database
codeql database create ruby-db --language=ruby --source-root=.

# Download query pack
codeql pack download codeql/ruby-queries

# Run analysis
codeql database analyze ruby-db codeql/ruby-queries:codeql-suites/ruby-security-and-quality.qls --format=sarif-latest --output=docs/results/codeql.sarif
```

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
   
   # Opengrep - Pattern-based security scanner
   opengrep --config=opengrep.yml --json --output=docs/results/opengrep.json .
   
   # CodeQL - Semantic analysis
   codeql database create ruby-db --language=ruby --source-root=.
   codeql database analyze ruby-db codeql/ruby-queries:codeql-suites/ruby-security-and-quality.qls --format=sarif-latest --output=docs/results/codeql.sarif
   
   # DevSkim - Microsoft security linter
   devskim analyze -I . -O docs/results/devskim.sarif -f sarif
   devskim analyze -I . -O docs/results/devskim.txt -f text
   ```

4. **Run all tools via GitHub Actions**:
   Push to repository or create PR to trigger all workflows.

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
