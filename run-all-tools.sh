#!/bin/bash
# Don't exit on errors - continue with other tools
set +e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to run a tool with error handling
run_tool() {
    local tool_name="$1"
    local command="$2"
    local output_file="$3"
    
    print_status "Running $tool_name..."
    
    if eval "$command"; then
        if [[ -f "$output_file" && -s "$output_file" ]]; then
            print_success "$tool_name completed successfully - output saved to $output_file"
        else
            print_warning "$tool_name completed but no output file generated"
        fi
    else
        print_error "$tool_name failed to run - continuing with other tools"
        return 0  # Don't fail the script, just continue
    fi
}

# Create results directory if it doesn't exist
mkdir -p docs/results

print_status "Starting SAST tool survey - running all tools locally"
print_status "Results will be saved to docs/results/"
echo

# 1. RuboCop - Ruby static code analyzer
run_tool "RuboCop" \
    "bundle exec rubocop --format json --out docs/results/rubocop.json" \
    "docs/results/rubocop.json"

echo

# 2. Brakeman - Rails security scanner
run_tool "Brakeman" \
    "bundle exec brakeman --force --format json --output docs/results/brakeman.json" \
    "docs/results/brakeman.json"

echo

# 3. Sorbet - Type checker
print_status "Running Sorbet..."
if bundle exec srb typecheck 2>&1 | tee docs/results/sorbet.txt; then
    print_success "Sorbet completed - output saved to docs/results/sorbet.txt"
else
    print_warning "Sorbet completed with type errors (expected) - output saved to docs/results/sorbet.txt"
fi

echo

# 4. AST-grep - Structural search
run_tool "AST-grep" \
    "ast-grep scan --json=pretty > docs/results/ast-grep.json" \
    "docs/results/ast-grep.json"

echo

# 5. OpenGrep - Community rules (recommended)
print_status "Running OpenGrep with community rules..."
if opengrep --config auto --json --output=docs/results/opengrep.json .; then
    print_success "OpenGrep (community rules) completed - output saved to docs/results/opengrep.json"
else
    print_error "OpenGrep (community rules) failed - continuing with other tools"
fi

echo

# 6. OpenGrep - Custom rules (for comparison)
print_status "Running OpenGrep with custom rules..."
if opengrep --config=opengrep.yml --json --output=docs/results/opengrep-custom.json .; then
    print_success "OpenGrep (custom rules) completed - output saved to docs/results/opengrep-custom.json"
else
    print_warning "OpenGrep (custom rules) failed or found no issues - continuing with other tools"
fi

echo

# 7. DevSkim - Microsoft security linter
print_status "Running DevSkim..."
if devskim analyze -I . -O docs/results/devskim.sarif -f sarif 2>/dev/null; then
    print_success "DevSkim (SARIF) completed - output saved to docs/results/devskim.sarif"
else
    print_warning "DevSkim (SARIF) failed - continuing with other tools"
fi

if devskim analyze -I . -O docs/results/devskim.txt -f text 2>/dev/null; then
    print_success "DevSkim (text) completed - output saved to docs/results/devskim.txt"
else
    print_warning "DevSkim (text) failed - continuing with other tools"
fi

echo

# 8. CodeQL - Semantic analysis (optional - slow)
print_status "Checking if CodeQL should be run..."
if command -v codeql >/dev/null 2>&1; then
    read -p "Run CodeQL? This can take 30+ seconds (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Running CodeQL database creation..."
        if codeql database create ruby-db --language=ruby --source-root=. --overwrite; then
            print_success "CodeQL database created"
            
            print_status "Running CodeQL analysis..."
            if codeql database analyze ruby-db codeql/ruby-queries:codeql-suites/ruby-security-and-quality.qls --format=sarif-latest --output=docs/results/codeql.sarif; then
                print_success "CodeQL analysis completed - output saved to docs/results/codeql.sarif"
            else
                print_error "CodeQL analysis failed - continuing with summary"
            fi
        else
            print_error "CodeQL database creation failed - continuing with summary"
        fi
    else
        print_warning "Skipping CodeQL (user choice)"
    fi
else
    print_warning "CodeQL not found - skipping (install with: brew install codeql)"
fi

echo
print_status "SAST tool survey completed!"
print_status "Results available in docs/results/"

# Summary of generated files
echo
print_status "Generated files:"
for file in docs/results/*; do
    if [[ -f "$file" ]]; then
        size=$(du -h "$file" | cut -f1)
        echo "  - $(basename "$file") ($size)"
    fi
done

echo
print_status "To view results:"
echo "  - JSON files: cat docs/results/<tool>.json | jq"
echo "  - SARIF files: Use GitHub Security tab or SARIF viewer"
echo "  - Text files: cat docs/results/<tool>.txt"