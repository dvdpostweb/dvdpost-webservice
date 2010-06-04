class CustomersController < ApplicationController
  before_filter :set_body_id

  def show
    @customer = current_customer
  end

  private
  def set_body_id
    @body_id = 'moncompte'
  end
end
