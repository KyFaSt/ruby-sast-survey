# frozen_string_literal: true

require 'sinatra'
require 'sqlite3'
require_relative 'models/user'
require_relative 'controllers/users_controller'

# SystemUtilities class with send() vulnerability
class SystemUtilities
  def ping_host(host)
    `ping -c 1 #{host}`
  end
  
  def check_disk(path)
    `df -h #{path}`
  end
  
  def list_files(dir)
    `ls -la #{dir}`
  end
end

# Simple vulnerable Sinatra app for SAST tool testing
class VulnerableApp < Sinatra::Base
  # SQL Injection vulnerability
  get '/user/:id' do
    db = SQLite3::Database.new("users.db")
    # Vulnerable: direct string interpolation
    result = db.execute("SELECT * FROM users WHERE id = #{params[:id]}")
    result.to_s
  end

  # XSS vulnerability
  get '/search' do
    query = params[:q]
    # Vulnerable: no escaping
    "<h1>Search results for: #{query}</h1>"
  end

  # Command injection vulnerability
  get '/ping' do
    host = params[:host]
    # Vulnerable: direct command execution
    result = `ping -c 1 #{host}`
    "<pre>#{result}</pre>"
  end

  # Path traversal vulnerability
  get '/file' do
    filename = params[:name]
    # Vulnerable: no path validation
    File.read("files/#{filename}")
  end

  # send() method injection vulnerability
  get '/system/:action' do
    util = SystemUtilities.new
    method = params[:action]
    argument = params[:arg]
    
    # Vulnerable: Dynamic method call with user input
    result = util.send(method, argument)
    "<pre>#{result}</pre>"
  end
end
