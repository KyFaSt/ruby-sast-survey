#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'time'

# Create human-readable reports from SAST tool results
class ReadableReportsGenerator
  def initialize
    @timestamp = Time.now.strftime('%Y-%m-%d %H:%M:%S')
  end

  def create_ast_grep_report
    data = JSON.parse(File.read('ast-grep.json'))
    
    File.open('ast-grep-readable.md', 'w') do |f|
      f.puts '# AST-grep Security Analysis Report'
      f.puts "Generated: #{@timestamp}"
      f.puts 'Project: Ruby SAST Survey'
      f.puts "Total Findings: #{data.length}"
      f.puts
      
      f.puts '## Summary by Severity'
      severity_count = data.group_by { |finding| finding['severity'] || 'Unknown' }
                           .transform_values(&:length)
      
      severity_count.each { |sev, count| f.puts "- #{sev}: #{count} findings" }
      
      f.puts
      f.puts '## Detailed Findings'
      f.puts
      
      data.each_with_index do |finding, idx|
        f.puts "### Finding #{idx + 1}: #{finding['ruleId'] || 'Unknown Rule'}"
        f.puts "**File:** `#{finding['file'] || 'Unknown'}`"
        f.puts "**Line:** #{finding.dig('range', 'start', 'line') || 'Unknown'}"
        f.puts "**Severity:** #{finding['severity'] || 'Unknown'}"
        f.puts "**Message:** #{finding['message'] || 'No message'}"
        f.puts "**Code:** `#{finding['text']&.strip}`" if finding['text']
        f.puts
        f.puts '---'
        f.puts
      end
    end
  end

  def create_brakeman_report
    data = JSON.parse(File.read('brakeman-final.json'))
    
    File.open('brakeman-readable.md', 'w') do |f|
      f.puts '# Brakeman Security Analysis Report'
      f.puts "Generated: #{@timestamp}"
      f.puts 'Project: Ruby SAST Survey'
      f.puts "Brakeman Version: #{data.dig('scan_info', 'brakeman_version')}"
      f.puts "Rails Version: #{data.dig('scan_info', 'rails_version')}"
      f.puts "Total Security Warnings: #{data.dig('scan_info', 'security_warnings')}"
      f.puts
      
      warnings = data['warnings'] || []
      
      # Summary by warning type
      f.puts '## Summary by Vulnerability Type'
      type_count = warnings.group_by { |w| w['warning_type'] }
                          .transform_values(&:length)
      
      type_count.sort.each { |wtype, count| f.puts "- #{wtype}: #{count} findings" }
      
      # Summary by confidence
      f.puts
      f.puts '## Summary by Confidence Level'
      confidence_count = warnings.group_by { |w| w['confidence'] }
                               .transform_values(&:length)
      
      %w[High Medium Weak].each do |conf|
        f.puts "- #{conf}: #{confidence_count[conf] || 0} findings"
      end
      
      f.puts
      f.puts '## Detailed Findings'
      f.puts
      
      warnings.each_with_index do |warning, idx|
        f.puts "### Finding #{idx + 1}: #{warning['warning_type']}"
        f.puts "**File:** `#{warning['file']}`"
        f.puts "**Line:** #{warning['line']}"
        f.puts "**Confidence:** #{warning['confidence']}"
        f.puts "**Message:** #{warning['message']}"
        f.puts "**Code:** `#{warning['code']}`"
        f.puts "**User Input:** `#{warning['user_input']}`" if warning['user_input']
        f.puts "**Documentation:** #{warning['link']}"
        f.puts
        f.puts '---'
        f.puts
      end
    end
  end

  def create_codeql_report
    data = JSON.parse(File.read('codeql-final.json'))
    
    File.open('codeql-readable.md', 'w') do |f|
      f.puts '# CodeQL Security Analysis Report'
      f.puts "Generated: #{@timestamp}"
      f.puts 'Project: Ruby SAST Survey'
      f.puts "CodeQL Version: #{data['version']}"
      f.puts "Total Findings: #{data['total_findings']}"
      f.puts
      
      results = data['results'] || []
      
      # Summary by severity
      f.puts '## Summary by Severity'
      severity_count = results.group_by { |r| r['severity'] }
                             .transform_values(&:length)
      
      severity_count.sort.each { |sev, count| f.puts "- #{sev}: #{count} findings" }
      
      # Summary by rule
      f.puts
      f.puts '## Summary by Rule Type'
      rule_count = results.group_by { |r| r['rule_id'] }
                         .transform_values(&:length)
      
      rule_count.sort.each { |rule, count| f.puts "- #{rule}: #{count} findings" }
      
      f.puts
      f.puts '## Detailed Findings'
      f.puts
      
      results.each_with_index do |result, idx|
        f.puts "### Finding #{idx + 1}: #{result['rule_id']}"
        f.puts "**File:** `#{result['file']}`"
        f.puts "**Line:** #{result['line']}"
        f.puts "**Severity:** #{result['severity']}"
        f.puts "**Message:** #{result['message']}"
        f.puts "**CWE:** #{result['cwe'].join(', ')}" if result['cwe']
        f.puts
        f.puts '---'
        f.puts
      end
    end
  end

  def create_opengrep_report
    data = JSON.parse(File.read('opengrep-final.json'))
    
    File.open('opengrep-readable.md', 'w') do |f|
      f.puts '# OpenGrep Security Analysis Report'
      f.puts "Generated: #{@timestamp}"
      f.puts 'Project: Ruby SAST Survey'
      f.puts "OpenGrep Version: #{data['version']}"
      f.puts "Total Findings: #{data['results']&.length || 0}"
      f.puts
      
      results = data['results'] || []
      
      # Summary by severity
      f.puts '## Summary by Severity'
      severity_count = results.group_by { |r| r.dig('extra', 'severity') }
                             .transform_values(&:length)
      
      severity_count.sort.each { |sev, count| f.puts "- #{sev}: #{count} findings" }
      
      # Summary by check
      f.puts
      f.puts '## Summary by Check Type'
      check_count = results.group_by { |r| r['check_id'] }
                          .transform_values(&:length)
      
      check_count.sort.each { |check, count| f.puts "- #{check}: #{count} findings" }
      
      f.puts
      f.puts '## Detailed Findings'
      f.puts
      
      results.each_with_index do |result, idx|
        f.puts "### Finding #{idx + 1}: #{result['check_id']}"
        f.puts "**File:** `#{result['path']}`"
        f.puts "**Line:** #{result.dig('start', 'line')}"
        f.puts "**Severity:** #{result.dig('extra', 'severity')}"
        f.puts "**Message:** #{result.dig('extra', 'message')}"
        f.puts "**Code:** `#{result.dig('extra', 'lines')&.strip}`"
        cwe = result.dig('extra', 'metadata', 'cwe')
        f.puts "**CWE:** #{cwe}" if cwe
        f.puts
        f.puts '---'
        f.puts
      end
    end
  end

  def create_rubocop_report
    data = JSON.parse(File.read('rubocop.json'))
    
    File.open('rubocop-readable.md', 'w') do |f|
      f.puts '# RuboCop Analysis Report'
      f.puts "Generated: #{@timestamp}"
      f.puts 'Project: Ruby SAST Survey'
      
      # Count total offenses
      files = data['files'] || []
      total_offenses = files.sum { |file| file['offenses']&.length || 0 }
      f.puts "Total Offenses: #{total_offenses}"
      f.puts
      
      # Collect all offenses
      all_offenses = files.flat_map { |file| file['offenses'] || [] }
      
      # Summary by severity
      f.puts '## Summary by Severity'
      severity_count = all_offenses.group_by { |o| o['severity'] }
                                  .transform_values(&:length)
      
      severity_count.sort.each { |sev, count| f.puts "- #{sev}: #{count} findings" }
      
      # Summary by cop
      f.puts
      f.puts '## Summary by Cop (Rule)'
      cop_count = all_offenses.group_by { |o| o['cop_name'] }
                             .transform_values(&:length)
      
      cop_count.sort.each { |cop, count| f.puts "- #{cop}: #{count} findings" }
      
      f.puts
      f.puts '## Detailed Findings'
      f.puts
      
      finding_num = 1
      files.each do |file|
        offenses = file['offenses']
        next unless offenses&.any?
        
        f.puts
        f.puts "#### File: `#{file['path']}`"
        f.puts
        
        offenses.each do |offense|
          f.puts "**Finding #{finding_num}:** #{offense['cop_name']}"
          f.puts "- **Line:** #{offense.dig('location', 'start_line')}"
          f.puts "- **Column:** #{offense.dig('location', 'start_column')}"
          f.puts "- **Severity:** #{offense['severity']}"
          f.puts "- **Message:** #{offense['message']}"
          f.puts
          finding_num += 1
        end
      end
    end
  end

  def create_devskim_report
    data = JSON.parse(File.read('devskim.sarif'))
    
    File.open('devskim-readable.md', 'w') do |f|
      f.puts '# DevSkim Security Analysis Report'
      f.puts "Generated: #{@timestamp}"
      f.puts 'Project: Ruby SAST Survey'
      
      results = data.dig('runs', 0, 'results') || []
      f.puts "Total Findings: #{results.length}"
      f.puts
      
      # Summary by severity
      f.puts '## Summary by Severity'
      severity_count = results.group_by { |r| r['level'] || 'unknown' }
                             .transform_values(&:length)
      
      severity_count.sort.each { |sev, count| f.puts "- #{sev}: #{count} findings" }
      
      # Most common rules
      f.puts
      f.puts '## Most Common Rules'
      rule_count = results.group_by { |r| r['ruleId'] }
                         .transform_values(&:length)
      
      rule_count.sort_by { |_, count| -count }.first(10).each do |rule, count|
        f.puts "- #{rule}: #{count} findings"
      end
      
      f.puts
      f.puts '## Detailed Findings (First 20)'
      f.puts
      
      results.first(20).each_with_index do |result, idx|
        f.puts "### Finding #{idx + 1}: #{result['ruleId']}"
        location = result.dig('locations', 0, 'physicalLocation')
        f.puts "**File:** `#{location.dig('artifactLocation', 'uri')}`"
        f.puts "**Line:** #{location.dig('region', 'startLine')}"
        f.puts "**Message:** #{result.dig('message', 'text')}"
        f.puts
        f.puts '---'
        f.puts
      end
      
      f.puts "\n*... and #{results.length - 20} more findings*" if results.length > 20
    end
  end

  def create_master_summary
    File.open('master-summary.md', 'w') do |f|
      f.puts '# Ruby SAST Survey - Master Summary Report'
      f.puts "Generated: #{@timestamp}"
      f.puts 'Project: Comprehensive Ruby Security Analysis'
      f.puts
      
      f.puts '## Tool Coverage Summary'
      f.puts
      f.puts '| Tool | Findings | Focus Area | Readable Report |'
      f.puts '|------|----------|------------|----------------|'
      
      tool_data = []
      
      # AST-grep
      ast_data = JSON.parse(File.read('ast-grep.json'))
      tool_data << ['AST-grep', ast_data.length, 'Pattern matching', 'ast-grep-readable.md']
      
      # Brakeman
      brak_data = JSON.parse(File.read('brakeman-final.json'))
      tool_data << ['Brakeman', brak_data.dig('scan_info', 'security_warnings'), 'Rails security', 'brakeman-readable.md']
      
      # CodeQL
      codeql_data = JSON.parse(File.read('codeql-final.json'))
      tool_data << ['CodeQL', codeql_data['total_findings'], 'Advanced analysis', 'codeql-readable.md']
      
      # OpenGrep
      opengrep_data = JSON.parse(File.read('opengrep-final.json'))
      tool_data << ['OpenGrep', opengrep_data['results']&.length || 0, 'Community rules', 'opengrep-readable.md']
      
      # RuboCop
      rubocop_data = JSON.parse(File.read('rubocop.json'))
      total_offenses = (rubocop_data['files'] || []).sum { |f| f['offenses']&.length || 0 }
      tool_data << ['RuboCop', total_offenses, 'Style + security', 'rubocop-readable.md']
      
      # DevSkim
      devskim_data = JSON.parse(File.read('devskim.sarif'))
      tool_data << ['DevSkim', devskim_data.dig('runs', 0, 'results')&.length || 0, 'Microsoft rules', 'devskim-readable.md']
      
      # Sorbet
      tool_data << ['Sorbet', 'Manual', 'Type checking', 'sorbet.txt']
      
      total_findings = 0
      tool_data.each do |tool, count, focus, report|
        if count.is_a?(Integer)
          total_findings += count
          f.puts "| #{tool} | #{count} | #{focus} | #{report} |"
        else
          f.puts "| #{tool} | #{count} | #{focus} | #{report} |"
        end
      end
      
      f.puts "| **TOTAL** | **#{total_findings}** | **All aspects** | **7 reports** |"
      f.puts
      
      f.puts '## Key Vulnerability Types Found'
      f.puts '- SQL Injection (multiple tools)'
      f.puts '- Command Injection (multiple tools)'
      f.puts '- Cross-Site Scripting (XSS)'
      f.puts '- Mass Assignment'
      f.puts '- Path Traversal'
      f.puts '- Open Redirect'
      f.puts '- Code Injection (including send() vulnerability)'
      f.puts '- Regular Expression DoS (ReDoS)'
      f.puts '- Insecure Deserialization'
      f.puts '- Style and Quality Issues'
      f.puts
      
      f.puts '## Special Finding: send() Vulnerability'
      f.puts '**Only CodeQL detected** the sophisticated Ruby metaprogramming vulnerability using `send()` method:'
      f.puts '- **Location:** app.rb:62'
      f.puts '- **Pattern:** `util.send(method, argument)` with user-controlled method name'
      f.puts '- **Risk:** Arbitrary method invocation leading to code execution'
      f.puts '- **Detection:** Advanced taint tracking required'
      f.puts
      
      f.puts '## Files Generated'
      f.puts '- `master-summary.md` - This overview report'
      f.puts '- `ast-grep-readable.md` - AST-grep detailed findings'
      f.puts '- `brakeman-readable.md` - Brakeman detailed findings'
      f.puts '- `codeql-readable.md` - CodeQL detailed findings'
      f.puts '- `opengrep-readable.md` - OpenGrep detailed findings'
      f.puts '- `rubocop-readable.md` - RuboCop detailed findings'
      f.puts '- `devskim-readable.md` - DevSkim detailed findings'
      f.puts '- `sorbet.txt` - Sorbet type checking output'
      f.puts
    end
  end

  def run
    puts 'Creating human-readable reports...'
    
    create_ast_grep_report
    puts '✅ AST-grep report created'
    
    create_brakeman_report
    puts '✅ Brakeman report created'
    
    create_codeql_report
    puts '✅ CodeQL report created'
    
    create_opengrep_report
    puts '✅ OpenGrep report created'
    
    create_rubocop_report
    puts '✅ RuboCop report created'
    
    create_devskim_report
    puts '✅ DevSkim report created'
    
    create_master_summary
    puts '✅ Master summary created'
    
    puts
    puts '🎉 All human-readable reports generated successfully!'
  end
end

# Run the generator if this file is executed directly
if __FILE__ == $PROGRAM_NAME
  generator = ReadableReportsGenerator.new
  generator.run
end