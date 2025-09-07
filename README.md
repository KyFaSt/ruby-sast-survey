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
devskim analyze . --output-format json --output-file docs/results/devskim.json
```

### 6. CodeQL
GitHub's semantic code analysis engine.
```bash
# Requires CodeQL CLI setup
codeql database create ruby-db --language=ruby
codeql database analyze ruby-db --format=json --output=docs/results/codeql.json
```

## Quick Start

1. **Clone and setup**:
   ```bash
   git clone <repository>
   cd ruby-sast-survey
   bundle install
   ```

2. **Run individual tools**:
   ```bash
   # Brakeman (Rails-focused, requires --force for non-Rails apps)
   bundle exec brakeman --force
   
   # RuboCop (general Ruby)
   bundle exec rubocop
   
   # Opengrep (custom patterns)
   opengrep --config=opengrep.yml .
   ```

3. **Run all tools via GitHub Actions**:
   Push to repository or create PR to trigger all workflows.

## Running Tools Locally

After running `bundle install`, you can execute any of the Ruby-based tools locally:

### RuboCop
```bash
# Run with default configuration
bundle exec rubocop

# Run on specific files/directories
bundle exec rubocop app.rb controllers/ models/

# Generate JSON output
bundle exec rubocop --format json --out docs/results/rubocop.json
```

### Brakeman
```bash
# Run with default configuration (uses .brakeman.yml)
# Note: Use --force since this is a Ruby sample without full Rails installation
bundle exec brakeman --force

# Generate JSON output
bundle exec brakeman --force --format json --output docs/results/brakeman.json

# Show only high confidence warnings
bundle exec brakeman --force --confidence-level 2
```

### Sorbet
```bash
# Initialize Sorbet in the project (first time only)
# Note: May require additional gems like ruby_parser for full initialization
bundle exec srb init

# Run type checking and save output
bundle exec srb typecheck 2>&1 | tee docs/results/sorbet.txt

# Type check specific files
bundle exec srb typecheck app.rb

# Generate RBI files for gems (requires full setup)
bundle exec srb rbi gems
```

**Note**: Sorbet initialization may fail in sample projects due to missing dependencies. The type checker itself works but will report many errors in sample/demo code that lacks proper type annotations. With the added type annotations, Sorbet reports 193 errors, which is expected for this sample application due to missing Sinatra type definitions and intentionally vulnerable code patterns.

### AST-grep
```bash
# Run with JSON output (requires ast-grep project initialization)
ast-grep scan --json=pretty > docs/results/ast-grep.json

# Run with default output
ast-grep scan

# Initialize ast-grep project (first time only)
ast-grep new

# Test individual patterns
ast-grep --pattern 'system($A)' --lang ruby .
```

### Opengrep (Semgrep)
```bash
# Install opengrep (first time only)
curl -fsSL https://raw.githubusercontent.com/opengrep/opengrep/main/install.sh | bash
export PATH='/Users/kyliestradley/.opengrep/cli/latest':$PATH

# Run with JSON output
opengrep --config=opengrep.yml --json --output=docs/results/opengrep.json .

# Run with default output
opengrep --config=opengrep.yml .

# Test with built-in rules
opengrep --config=auto .
```

## Results

Tool outputs are saved in the `docs/results/` directory:

- **AST-grep**: 4 findings (`ast-grep.json`)
- **Opengrep**: 1 finding (`opengrep.json`)
- **Brakeman**: 8 warnings (`brakeman.json`)
- **RuboCop**: 28 offenses (`rubocop.json`)
- **Sorbet**: 193 errors (`sorbet.txt`)

See `docs/tool-comparison.md` for detailed analysis of each tool's strengths and weaknesses.

## Contributing

Feel free to add more vulnerable code examples or improve tool configurations!

## ⚠️ Security Notice

This repository contains intentionally vulnerable code for educational purposes. **Do not deploy this code to production environments.**
