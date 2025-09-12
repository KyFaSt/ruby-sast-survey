# RuboCop Analysis Report
Generated: 2025-09-11 14:47:48
Project: Ruby SAST Survey
Total Offenses: 161

## Summary by Severity
- convention: 159 findings
- warning: 2 findings

## Summary by Cop (Rule)
- Bundler/OrderedGems: 2 findings
- Layout/ExtraSpacing: 6 findings
- Layout/LineLength: 2 findings
- Layout/MultilineMethodCallIndentation: 10 findings
- Layout/TrailingEmptyLines: 4 findings
- Layout/TrailingWhitespace: 80 findings
- Lint/EmptyClass: 2 findings
- Metrics/AbcSize: 7 findings
- Metrics/BlockLength: 6 findings
- Metrics/ClassLength: 1 findings
- Metrics/CyclomaticComplexity: 7 findings
- Metrics/MethodLength: 8 findings
- Metrics/PerceivedComplexity: 7 findings
- Naming/PredicateMethod: 1 findings
- Rails/TimeZone: 1 findings
- Security/Eval: 1 findings
- Security/YAMLLoad: 1 findings
- Style/Documentation: 2 findings
- Style/FileWrite: 1 findings
- Style/FrozenStringLiteralComment: 2 findings
- Style/IdenticalConditionalBranches: 2 findings
- Style/IfUnlessModifier: 1 findings
- Style/RedundantRegexpEscape: 4 findings
- Style/RedundantSelf: 2 findings
- Style/StringLiterals: 1 findings

## Detailed Findings


#### File: `Gemfile`

**Finding 1:** Style/FrozenStringLiteralComment
- **Line:** 1
- **Column:** 1
- **Severity:** convention
- **Message:** Missing frozen string literal comment.

**Finding 2:** Bundler/OrderedGems
- **Line:** 9
- **Column:** 3
- **Severity:** convention
- **Message:** Gems should be sorted in an alphabetical order within their section of the Gemfile. Gem `rubocop-performance` should appear before `rubocop-rails`.

**Finding 3:** Bundler/OrderedGems
- **Line:** 10
- **Column:** 3
- **Severity:** convention
- **Message:** Gems should be sorted in an alphabetical order within their section of the Gemfile. Gem `brakeman` should appear before `rubocop-performance`.

**Finding 4:** Layout/TrailingEmptyLines
- **Line:** 16
- **Column:** 4
- **Severity:** convention
- **Message:** Final newline missing.


#### File: `app.rb`

**Finding 5:** Layout/TrailingWhitespace
- **Line:** 13
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 6:** Layout/TrailingWhitespace
- **Line:** 17
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 7:** Style/StringLiterals
- **Line:** 27
- **Column:** 32
- **Severity:** convention
- **Message:** Prefer single-quoted strings when you don't need string interpolation or special symbols.

**Finding 8:** Layout/TrailingWhitespace
- **Line:** 60
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.


#### File: `controllers/application_controller.rb`

**Finding 9:** Lint/EmptyClass
- **Line:** 4
- **Column:** 1
- **Severity:** warning
- **Message:** Empty class detected.


#### File: `controllers/payments_controller.rb`

**Finding 10:** Style/FrozenStringLiteralComment
- **Line:** 1
- **Column:** 1
- **Severity:** convention
- **Message:** Missing frozen string literal comment.

**Finding 11:** Layout/TrailingEmptyLines
- **Line:** 14
- **Column:** 4
- **Severity:** convention
- **Message:** Final newline missing.


#### File: `controllers/users_controller.rb`

**Finding 12:** Style/Documentation
- **Line:** 5
- **Column:** 1
- **Severity:** convention
- **Message:** Missing top-level documentation comment for `class UsersController`.

**Finding 13:** Layout/TrailingWhitespace
- **Line:** 9
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 14:** Style/IfUnlessModifier
- **Line:** 11
- **Column:** 5
- **Severity:** convention
- **Message:** Favor modifier `if` usage when having a single-line body. Another good alternative is the usage of control flow `&&`/`||`.

**Finding 15:** Layout/TrailingWhitespace
- **Line:** 14
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 16:** Layout/TrailingWhitespace
- **Line:** 17
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 17:** Layout/TrailingWhitespace
- **Line:** 22
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 18:** Layout/ExtraSpacing
- **Line:** 29
- **Column:** 31
- **Severity:** convention
- **Message:** Unnecessary spacing detected.

**Finding 19:** Layout/ExtraSpacing
- **Line:** 30
- **Column:** 44
- **Severity:** convention
- **Message:** Unnecessary spacing detected.

**Finding 20:** Layout/ExtraSpacing
- **Line:** 34
- **Column:** 31
- **Severity:** convention
- **Message:** Unnecessary spacing detected.

**Finding 21:** Layout/TrailingWhitespace
- **Line:** 34
- **Column:** 63
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 22:** Layout/ExtraSpacing
- **Line:** 35
- **Column:** 46
- **Severity:** convention
- **Message:** Unnecessary spacing detected.

**Finding 23:** Layout/ExtraSpacing
- **Line:** 40
- **Column:** 33
- **Severity:** convention
- **Message:** Unnecessary spacing detected.

**Finding 24:** Layout/ExtraSpacing
- **Line:** 41
- **Column:** 31
- **Severity:** convention
- **Message:** Unnecessary spacing detected.

**Finding 25:** Layout/TrailingWhitespace
- **Line:** 43
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 26:** Layout/TrailingEmptyLines
- **Line:** 49
- **Column:** 4
- **Severity:** convention
- **Message:** Final newline missing.


#### File: `docs/results/create_readable_reports.rb`

**Finding 27:** Metrics/ClassLength
- **Line:** 8
- **Column:** 1
- **Severity:** convention
- **Message:** Class has too many lines. [307/100]

**Finding 28:** Rails/TimeZone
- **Line:** 10
- **Column:** 23
- **Severity:** convention
- **Message:** Do not use `Time.now` without zone. Use one of `Time.zone.now`, `Time.current`, `Time.now.in_time_zone`, `Time.now.utc`, `Time.now.getlocal`, `Time.now.xmlschema`, `Time.now.iso8601`, `Time.now.jisx0301`, `Time.now.rfc3339`, `Time.now.httpdate`, `Time.now.to_i`, `Time.now.to_f` instead.

**Finding 29:** Metrics/AbcSize
- **Line:** 13
- **Column:** 3
- **Severity:** convention
- **Message:** Assignment Branch Condition size for `create_ast_grep_report` is too high. [<8, 37, 12> 39.71/17]

**Finding 30:** Metrics/CyclomaticComplexity
- **Line:** 13
- **Column:** 3
- **Severity:** convention
- **Message:** Cyclomatic complexity for `create_ast_grep_report` is too high. [13/7]

**Finding 31:** Metrics/MethodLength
- **Line:** 13
- **Column:** 3
- **Severity:** convention
- **Message:** Method has too many lines. [26/10]

**Finding 32:** Metrics/PerceivedComplexity
- **Line:** 13
- **Column:** 3
- **Severity:** convention
- **Message:** Perceived complexity for `create_ast_grep_report` is too high. [13/8]

**Finding 33:** Layout/TrailingWhitespace
- **Line:** 15
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 34:** Layout/TrailingWhitespace
- **Line:** 22
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 35:** Layout/TrailingWhitespace
- **Line:** 26
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 36:** Layout/TrailingWhitespace
- **Line:** 28
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 37:** Layout/TrailingWhitespace
- **Line:** 32
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 38:** Metrics/AbcSize
- **Line:** 47
- **Column:** 3
- **Severity:** convention
- **Message:** Assignment Branch Condition size for `create_brakeman_report` is too high. [<12, 54, 10> 56.21/17]

**Finding 39:** Metrics/CyclomaticComplexity
- **Line:** 47
- **Column:** 3
- **Severity:** convention
- **Message:** Cyclomatic complexity for `create_brakeman_report` is too high. [11/7]

**Finding 40:** Metrics/MethodLength
- **Line:** 47
- **Column:** 3
- **Severity:** convention
- **Message:** Method has too many lines. [38/10]

**Finding 41:** Metrics/PerceivedComplexity
- **Line:** 47
- **Column:** 3
- **Severity:** convention
- **Message:** Perceived complexity for `create_brakeman_report` is too high. [11/8]

**Finding 42:** Layout/TrailingWhitespace
- **Line:** 49
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 43:** Metrics/BlockLength
- **Line:** 50
- **Column:** 5
- **Severity:** convention
- **Message:** Block has too many lines. [35/25]

**Finding 44:** Layout/TrailingWhitespace
- **Line:** 58
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 45:** Layout/TrailingWhitespace
- **Line:** 60
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 46:** Layout/MultilineMethodCallIndentation
- **Line:** 64
- **Column:** 27
- **Severity:** convention
- **Message:** Align `.transform_values` with `.group_by` on line 63.

**Finding 47:** Layout/TrailingWhitespace
- **Line:** 65
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 48:** Layout/TrailingWhitespace
- **Line:** 67
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 49:** Layout/MultilineMethodCallIndentation
- **Line:** 72
- **Column:** 32
- **Severity:** convention
- **Message:** Align `.transform_values` with `.group_by` on line 71.

**Finding 50:** Layout/TrailingWhitespace
- **Line:** 73
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 51:** Layout/TrailingWhitespace
- **Line:** 77
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 52:** Layout/TrailingWhitespace
- **Line:** 81
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 53:** Metrics/AbcSize
- **Line:** 98
- **Column:** 3
- **Severity:** convention
- **Message:** Assignment Branch Condition size for `create_codeql_report` is too high. [<13, 49, 9> 51.49/17]

**Finding 54:** Metrics/CyclomaticComplexity
- **Line:** 98
- **Column:** 3
- **Severity:** convention
- **Message:** Cyclomatic complexity for `create_codeql_report` is too high. [10/7]

**Finding 55:** Metrics/MethodLength
- **Line:** 98
- **Column:** 3
- **Severity:** convention
- **Message:** Method has too many lines. [33/10]

**Finding 56:** Metrics/PerceivedComplexity
- **Line:** 98
- **Column:** 3
- **Severity:** convention
- **Message:** Perceived complexity for `create_codeql_report` is too high. [10/8]

**Finding 57:** Layout/TrailingWhitespace
- **Line:** 100
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 58:** Metrics/BlockLength
- **Line:** 101
- **Column:** 5
- **Severity:** convention
- **Message:** Block has too many lines. [30/25]

**Finding 59:** Layout/TrailingWhitespace
- **Line:** 108
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 60:** Layout/TrailingWhitespace
- **Line:** 110
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 61:** Layout/MultilineMethodCallIndentation
- **Line:** 114
- **Column:** 30
- **Severity:** convention
- **Message:** Align `.transform_values` with `.group_by` on line 113.

**Finding 62:** Layout/TrailingWhitespace
- **Line:** 115
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 63:** Layout/TrailingWhitespace
- **Line:** 117
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 64:** Layout/MultilineMethodCallIndentation
- **Line:** 122
- **Column:** 26
- **Severity:** convention
- **Message:** Align `.transform_values` with `.group_by` on line 121.

**Finding 65:** Layout/TrailingWhitespace
- **Line:** 123
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 66:** Layout/TrailingWhitespace
- **Line:** 125
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 67:** Layout/TrailingWhitespace
- **Line:** 129
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 68:** Metrics/AbcSize
- **Line:** 144
- **Column:** 3
- **Severity:** convention
- **Message:** Assignment Branch Condition size for `create_opengrep_report` is too high. [<14, 51, 12> 54.23/17]

**Finding 69:** Metrics/CyclomaticComplexity
- **Line:** 144
- **Column:** 3
- **Severity:** convention
- **Message:** Cyclomatic complexity for `create_opengrep_report` is too high. [13/7]

**Finding 70:** Metrics/MethodLength
- **Line:** 144
- **Column:** 3
- **Severity:** convention
- **Message:** Method has too many lines. [35/10]

**Finding 71:** Metrics/PerceivedComplexity
- **Line:** 144
- **Column:** 3
- **Severity:** convention
- **Message:** Perceived complexity for `create_opengrep_report` is too high. [13/8]

**Finding 72:** Layout/TrailingWhitespace
- **Line:** 146
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 73:** Metrics/BlockLength
- **Line:** 147
- **Column:** 5
- **Severity:** convention
- **Message:** Block has too many lines. [32/25]

**Finding 74:** Layout/TrailingWhitespace
- **Line:** 154
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 75:** Layout/TrailingWhitespace
- **Line:** 156
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 76:** Layout/MultilineMethodCallIndentation
- **Line:** 160
- **Column:** 30
- **Severity:** convention
- **Message:** Align `.transform_values` with `.group_by` on line 159.

**Finding 77:** Layout/TrailingWhitespace
- **Line:** 161
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 78:** Layout/TrailingWhitespace
- **Line:** 163
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 79:** Layout/MultilineMethodCallIndentation
- **Line:** 168
- **Column:** 27
- **Severity:** convention
- **Message:** Align `.transform_values` with `.group_by` on line 167.

**Finding 80:** Layout/TrailingWhitespace
- **Line:** 169
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 81:** Layout/TrailingWhitespace
- **Line:** 171
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 82:** Layout/TrailingWhitespace
- **Line:** 175
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 83:** Metrics/AbcSize
- **Line:** 192
- **Column:** 3
- **Severity:** convention
- **Message:** Assignment Branch Condition size for `create_rubocop_report` is too high. [<20, 51, 16> 57.07/17]

**Finding 84:** Metrics/CyclomaticComplexity
- **Line:** 192
- **Column:** 3
- **Severity:** convention
- **Message:** Cyclomatic complexity for `create_rubocop_report` is too high. [17/7]

**Finding 85:** Metrics/MethodLength
- **Line:** 192
- **Column:** 3
- **Severity:** convention
- **Message:** Method has too many lines. [40/10]

**Finding 86:** Metrics/PerceivedComplexity
- **Line:** 192
- **Column:** 3
- **Severity:** convention
- **Message:** Perceived complexity for `create_rubocop_report` is too high. [17/8]

**Finding 87:** Layout/TrailingWhitespace
- **Line:** 194
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 88:** Metrics/BlockLength
- **Line:** 195
- **Column:** 5
- **Severity:** convention
- **Message:** Block has too many lines. [37/25]

**Finding 89:** Layout/TrailingWhitespace
- **Line:** 199
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 90:** Layout/TrailingWhitespace
- **Line:** 205
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 91:** Layout/TrailingWhitespace
- **Line:** 208
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 92:** Layout/MultilineMethodCallIndentation
- **Line:** 212
- **Column:** 35
- **Severity:** convention
- **Message:** Align `.transform_values` with `.group_by` on line 211.

**Finding 93:** Layout/TrailingWhitespace
- **Line:** 213
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 94:** Layout/TrailingWhitespace
- **Line:** 215
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 95:** Layout/MultilineMethodCallIndentation
- **Line:** 220
- **Column:** 30
- **Severity:** convention
- **Message:** Align `.transform_values` with `.group_by` on line 219.

**Finding 96:** Layout/TrailingWhitespace
- **Line:** 221
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 97:** Layout/TrailingWhitespace
- **Line:** 223
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 98:** Layout/TrailingWhitespace
- **Line:** 227
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 99:** Layout/TrailingWhitespace
- **Line:** 232
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 100:** Layout/TrailingWhitespace
- **Line:** 236
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 101:** Metrics/AbcSize
- **Line:** 250
- **Column:** 3
- **Severity:** convention
- **Message:** Assignment Branch Condition size for `create_devskim_report` is too high. [<15, 49, 12> 52.63/17]

**Finding 102:** Metrics/CyclomaticComplexity
- **Line:** 250
- **Column:** 3
- **Severity:** convention
- **Message:** Cyclomatic complexity for `create_devskim_report` is too high. [12/7]

**Finding 103:** Metrics/MethodLength
- **Line:** 250
- **Column:** 3
- **Severity:** convention
- **Message:** Method has too many lines. [34/10]

**Finding 104:** Metrics/PerceivedComplexity
- **Line:** 250
- **Column:** 3
- **Severity:** convention
- **Message:** Perceived complexity for `create_devskim_report` is too high. [12/8]

**Finding 105:** Layout/TrailingWhitespace
- **Line:** 252
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 106:** Metrics/BlockLength
- **Line:** 253
- **Column:** 5
- **Severity:** convention
- **Message:** Block has too many lines. [31/25]

**Finding 107:** Layout/TrailingWhitespace
- **Line:** 257
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 108:** Layout/TrailingWhitespace
- **Line:** 261
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 109:** Layout/MultilineMethodCallIndentation
- **Line:** 265
- **Column:** 30
- **Severity:** convention
- **Message:** Align `.transform_values` with `.group_by` on line 264.

**Finding 110:** Layout/TrailingWhitespace
- **Line:** 266
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 111:** Layout/TrailingWhitespace
- **Line:** 268
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 112:** Layout/MultilineMethodCallIndentation
- **Line:** 273
- **Column:** 26
- **Severity:** convention
- **Message:** Align `.transform_values` with `.group_by` on line 272.

**Finding 113:** Layout/TrailingWhitespace
- **Line:** 274
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 114:** Layout/TrailingWhitespace
- **Line:** 278
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 115:** Layout/TrailingWhitespace
- **Line:** 282
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 116:** Layout/TrailingWhitespace
- **Line:** 293
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 117:** Metrics/AbcSize
- **Line:** 298
- **Column:** 3
- **Severity:** convention
- **Message:** Assignment Branch Condition size for `create_master_summary` is too high. [<16, 74, 11> 76.5/17]

**Finding 118:** Metrics/CyclomaticComplexity
- **Line:** 298
- **Column:** 3
- **Severity:** convention
- **Message:** Cyclomatic complexity for `create_master_summary` is too high. [11/7]

**Finding 119:** Metrics/MethodLength
- **Line:** 298
- **Column:** 3
- **Severity:** convention
- **Message:** Method has too many lines. [65/10]

**Finding 120:** Metrics/PerceivedComplexity
- **Line:** 298
- **Column:** 3
- **Severity:** convention
- **Message:** Perceived complexity for `create_master_summary` is too high. [12/8]

**Finding 121:** Metrics/BlockLength
- **Line:** 299
- **Column:** 5
- **Severity:** convention
- **Message:** Block has too many lines. [63/25]

**Finding 122:** Layout/TrailingWhitespace
- **Line:** 304
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 123:** Layout/TrailingWhitespace
- **Line:** 309
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 124:** Layout/TrailingWhitespace
- **Line:** 311
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 125:** Layout/TrailingWhitespace
- **Line:** 315
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 126:** Layout/LineLength
- **Line:** 318
- **Column:** 121
- **Severity:** convention
- **Message:** Line is too long. [122/120]

**Finding 127:** Layout/TrailingWhitespace
- **Line:** 319
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 128:** Layout/TrailingWhitespace
- **Line:** 323
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 129:** Layout/TrailingWhitespace
- **Line:** 327
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 130:** Layout/TrailingWhitespace
- **Line:** 332
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 131:** Layout/LineLength
- **Line:** 335
- **Column:** 121
- **Severity:** convention
- **Message:** Line is too long. [125/120]

**Finding 132:** Layout/TrailingWhitespace
- **Line:** 336
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 133:** Layout/TrailingWhitespace
- **Line:** 339
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 134:** Style/IdenticalConditionalBranches
- **Line:** 344
- **Column:** 11
- **Severity:** convention
- **Message:** Move `f.puts "| #{tool} | #{count} | #{focus} | #{report} |"` out of the conditional.

**Finding 135:** Style/IdenticalConditionalBranches
- **Line:** 346
- **Column:** 11
- **Severity:** convention
- **Message:** Move `f.puts "| #{tool} | #{count} | #{focus} | #{report} |"` out of the conditional.

**Finding 136:** Layout/TrailingWhitespace
- **Line:** 349
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 137:** Layout/TrailingWhitespace
- **Line:** 352
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 138:** Layout/TrailingWhitespace
- **Line:** 365
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 139:** Layout/TrailingWhitespace
- **Line:** 373
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 140:** Metrics/MethodLength
- **Line:** 387
- **Column:** 3
- **Severity:** convention
- **Message:** Method has too many lines. [17/10]

**Finding 141:** Layout/TrailingWhitespace
- **Line:** 389
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 142:** Layout/TrailingWhitespace
- **Line:** 392
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 143:** Layout/TrailingWhitespace
- **Line:** 395
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 144:** Layout/TrailingWhitespace
- **Line:** 398
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 145:** Layout/TrailingWhitespace
- **Line:** 401
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 146:** Layout/TrailingWhitespace
- **Line:** 404
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 147:** Layout/TrailingWhitespace
- **Line:** 407
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 148:** Layout/TrailingWhitespace
- **Line:** 410
- **Column:** 1
- **Severity:** convention
- **Message:** Trailing whitespace detected.

**Finding 149:** Layout/TrailingEmptyLines
- **Line:** 420
- **Column:** 4
- **Severity:** convention
- **Message:** Final newline missing.


#### File: `models/application_record.rb`

**Finding 150:** Lint/EmptyClass
- **Line:** 4
- **Column:** 1
- **Severity:** warning
- **Message:** Empty class detected.


#### File: `models/user.rb`

**Finding 151:** Style/Documentation
- **Line:** 5
- **Column:** 1
- **Severity:** convention
- **Message:** Missing top-level documentation comment for `class User`.

**Finding 152:** Security/Eval
- **Line:** 8
- **Column:** 5
- **Severity:** convention
- **Message:** The use of `eval` is a serious security risk.

**Finding 153:** Security/YAMLLoad
- **Line:** 19
- **Column:** 10
- **Severity:** convention
- **Message:** Prefer using `YAML.safe_load` over `YAML.load`.

**Finding 154:** Style/FileWrite
- **Line:** 24
- **Column:** 5
- **Severity:** convention
- **Message:** Use `File.write`.

**Finding 155:** Style/RedundantSelf
- **Line:** 25
- **Column:** 15
- **Severity:** convention
- **Message:** Redundant `self` detected.

**Finding 156:** Style/RedundantSelf
- **Line:** 31
- **Column:** 32
- **Severity:** convention
- **Message:** Redundant `self` detected.

**Finding 157:** Naming/PredicateMethod
- **Line:** 35
- **Column:** 7
- **Severity:** convention
- **Message:** Predicate method names should end with `?`.

**Finding 158:** Style/RedundantRegexpEscape
- **Line:** 37
- **Column:** 27
- **Severity:** convention
- **Message:** Redundant escape inside regexp literal

**Finding 159:** Style/RedundantRegexpEscape
- **Line:** 37
- **Column:** 29
- **Severity:** convention
- **Message:** Redundant escape inside regexp literal

**Finding 160:** Style/RedundantRegexpEscape
- **Line:** 37
- **Column:** 34
- **Severity:** convention
- **Message:** Redundant escape inside regexp literal

**Finding 161:** Style/RedundantRegexpEscape
- **Line:** 37
- **Column:** 48
- **Severity:** convention
- **Message:** Redundant escape inside regexp literal

