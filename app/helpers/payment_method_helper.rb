module PaymentMethodHelper
  def choose_partial
    params[:type] || 'index'
  end
end
