class PaymentMethodsController < ApplicationController
  def edit
  end

  def update
    @order_id = "#{current_customer.to_param}#{Time.now.strftime('%Y%m%d%H%M%S')}"
    @price = 0;
    case I18n.locale
    	when :fr
    		@ogone_language = 'fr_FR'
    		@template_ogone = 'Template_freetrial2FR.htm'
    	when :nl
    		@ogone_language = 'nl_NL';
    		@template_ogone = 'Template_freetrial2NL.htm'
    	when :en
    		@ogone_language = 'en_US';
    		@template_ogone = 'Template_freetrial2EN.htm'
    end
    if params['type'] == 'modification'
      @com='ogone change'
      internal_com = 'ogone_change'
      @url_back = url_for(:edit => 'show', :controller => 'customer_payment_methods', :customer_id => current_customer.to_param, :type => 'modification', :only_path => false, :protocol => 'http')
    else
      @com='Modification du mode de paiement'
      @url_back = url_for(:edit => 'show', :controller => 'customer_payment_methods', :customer_id => current_customer.to_param, :only_path => false, :protocol => 'http')
      internal_com = 'payment_method_change'
    end
    OgoneCheck.create(:orderid => @order_id, :amount => @price, :customers_id => current_customer.to_param, :context => internal_com, :site => 1)
    @hash = Digest::SHA1.hexdigest("#{@order_id}#{@price}EURdvdpost#{current_customer.to_param}#{@com}KILLBILL")
  end
end
