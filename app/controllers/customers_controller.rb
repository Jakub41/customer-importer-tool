# frozen_string_literal: true

class CustomersController < ApplicationController
  def index
    @customers = Customer.all.includes(:company, :user)
    @customers = @customers.where(company_id: company) if company.present?
  end

  private

  def company
    params[:company_id]
  end
end
