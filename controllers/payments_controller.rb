# app/controllers/payments_controller.rb
class PaymentsController < ApplicationController
  def create
    token = params[:token]
    process_payment(token)
  end

  private

  def process_payment(input)
    command = "charge --token=#{input}"
    system(command) # 🚨 Potential command injection
  end
end