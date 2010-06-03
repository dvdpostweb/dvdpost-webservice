class CustomersController < ApplicationController
  before_filter :set_body_id

  private
  def set_body_id
    @body_id = 'moncompte'
  end
end
