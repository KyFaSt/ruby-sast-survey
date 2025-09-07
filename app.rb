# typed: strict
# frozen_string_literal: true

require 'sinatra'
require 'sqlite3'
require 'sorbet-runtime'
require_relative 'models/user'
require_relative 'controllers/users_controller'

# Simple vulnerable Sinatra app for SAST tool testing
class VulnerableApp < Sinatra::Base
  extend T::Sig

  # SQL Injection vulnerability
  sig { returns(String) }
  def get_user_by_id
    get '/user/:id' do
      db = SQLite3::Database.new("users.db")
      # Vulnerable: direct string interpolation
      result = db.execute("SELECT * FROM users WHERE id = #{params[:id]}")
      result.to_s
    end
  end

  # XSS vulnerability
  sig { returns(String) }
  def search_users
    get '/search' do
      query = T.cast(params[:q], T.nilable(String))
      # Vulnerable: no escaping
      "<h1>Search results for: #{query}</h1>"
    end
  end

  # Command injection vulnerability
  sig { returns(String) }
  def ping_host
    get '/ping' do
      host = T.cast(params[:host], T.nilable(String))
      # Vulnerable: direct command execution
      result = `ping -c 1 #{host}`
      "<pre>#{result}</pre>"
    end
  end

  # Path traversal vulnerability
  get '/file' do
    filename = params[:name]
    # Vulnerable: no path validation
    File.read("files/#{filename}")
  end
end
