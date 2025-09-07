# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'
require_relative 'application_record'

class User < ApplicationRecord
  extend T::Sig

  # Vulnerable: Using eval on user input
  sig { params(formula: String).returns(T.untyped) }
  def self.calculate_score(formula)
    eval(formula)
  end

  # Vulnerable: Using send with user input
  sig { params(attr_name: String, value: T.untyped).returns(T.untyped) }
  def update_attribute_dynamically(attr_name, value)
    send("#{attr_name}=", value)
    save
  end

  # Vulnerable: YAML.load (unsafe deserialization)
  sig { params(yaml_string: String).returns(T.untyped) }
  def self.import_from_yaml(yaml_string)
    YAML.load(yaml_string)
  end

  # Vulnerable: File operations with user input
  sig { params(filename: String).void }
  def export_data(filename)
    File.open(filename, 'w') do |f|
      f.write(self.to_json)
    end
  end

  # Vulnerable: Using system calls
  sig { returns(T.nilable(T::Boolean)) }
  def backup_user_data
    system("backup_script.sh #{self.id}")
  end

  # Vulnerable: Regular expression DoS
  sig { params(email: String).returns(T::Boolean) }
  def validate_email_complex(email)
    # Catastrophic backtracking pattern
    regex = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/
    !!(email =~ regex)
  end

  # Vulnerable: SQL injection in custom query
  sig { params(name_pattern: String).returns(T::Array[User]) }
  def find_similar_users(name_pattern)
    User.find_by_sql("SELECT * FROM users WHERE name LIKE '#{name_pattern}'")
  end
end
