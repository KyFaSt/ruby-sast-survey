# frozen_string_literal: true

require_relative 'application_controller'

class UsersController < ApplicationController
  def search
    # Vulnerability 1: SQL Injection
    @users = User.where("name LIKE '%#{params[:q]}%'")
    
    # Vulnerability 2: Open Redirect
    if @users.empty?
      redirect_to params[:return_url]
    end
    
    # Vulnerability 3: Mass Assignment
    @user = User.new(user_params)
    
    # Vulnerability 4: Taint tracking example
    search_term = params[:q]
    processed_term = search_term.upcase
    sanitized_term = processed_term.strip
    
    # SQL injection through data flow
    @admins = User.where("role = 'admin' AND name LIKE '%#{sanitized_term}%'")
  end

  # Cross-file taint tracking example
  def calculate_user_score
    formula = params[:formula]  # 🚨 Taint source in controller
    @result = User.calculate_score(formula)  # 🎯 Flows to model method with eval()
  end

  def search_similar
    pattern = params[:pattern]  # 🚨 Taint source in controller  
    @users = User.find_similar_users(pattern)  # 🎯 Flows to model method with SQL injection
  end

  def export_user_data
    user = User.find(params[:id])
    filename = params[:filename]  # 🚨 Taint source in controller
    user.export_data(filename)   # 🎯 Flows to model method with path traversal
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :admin)
  end
end