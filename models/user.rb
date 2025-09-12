# frozen_string_literal: true

require_relative 'application_record'

class User < ApplicationRecord
  # Vulnerable: Using eval on user input
  def self.calculate_score(formula)
    eval(formula)
  end

  # Vulnerable: Using send with user input
  def update_attribute_dynamically(attr_name, value)
    send("#{attr_name}=", value)
    save
  end

  # Vulnerable: YAML.load (unsafe deserialization)
  def self.import_from_yaml(yaml_string)
    YAML.load(yaml_string)
  end

  # Vulnerable: File operations with user input
  def export_data(filename)
    File.open(filename, 'w') do |f|
      f.write(self.to_json)
    end
  end

  # Vulnerable: Using system calls
  def backup_user_data
    system("backup_script.sh #{self.id}")
  end

  # Vulnerable: Regular expression DoS
  def validate_email_complex(email)
    # Catastrophic backtracking pattern
    regex = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/
    !!(email =~ regex)
  end

  # Vulnerable: SQL injection in custom query
  def find_similar_users(name_pattern)
    User.find_by_sql("SELECT * FROM users WHERE name LIKE '#{name_pattern}'")
  end
end
