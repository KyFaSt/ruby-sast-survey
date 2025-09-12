OpenGrep Cross-File Test Results
=====================================================

Tested: 156 community rules against cross-file taint tracking vulnerabilities
Result: 14 findings within individual files, 0 cross-file detections

Cross-file test cases that OpenGrep missed:
1. params[:formula] → User.calculate_score(formula) → eval()
2. params[:pattern] → User.find_similar_users(pattern) → SQL injection  
3. params[:filename] → user.export_data(filename) → path traversal

Conclusion: OpenGrep's community rules excel at pattern matching within files 
but cannot trace taint flow across file boundaries like CodeQL can.
