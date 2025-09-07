# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'
require_relative 'application_controller'

class UsersController < ApplicationController
  extend T::Sig

  sig { void }
  def search
    # Vulnerability 1: SQL Injection
    @users = T.let(User.where("name LIKE '%#{params[:q]}%'"), T.untyped)
    
    # Vulnerability 2: Open Redirect
    if @users.empty?
      redirect_to T.cast(params[:return_url], String)
    end
    
    # Vulnerability 3: Mass Assignment
    @user = T.let(User.new(user_params), T.untyped)
    
    # Vulnerability 4: Taint tracking example
    search_term = T.cast(params[:q], String)
    processed_term = search_term.upcase
    sanitized_term = processed_term.strip
    
    # SQL injection through data flow
    @admins = T.let(User.where("role = 'admin' AND name LIKE '%#{sanitized_term}%'"), T.untyped)
  end
  
  private

  sig { returns(ActionController::Parameters) }
  def user_params
    params.require(:user).permit(:name, :email, :admin)
  end
end