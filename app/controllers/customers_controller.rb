class CustomersController < ApplicationController
  def show
    @customer = current_customer
  end
end
