module MessagesHelper
  def radio_question_for(form, attr, id)
    render :partial => 'messages/index/radio_question', :locals => {:f => form, :attr => attr, :id => id}
  end

  def tab_item_class(tab, active)
    tab == active ? 'active' : ''
  end

  def offline_payment_type(type)
    case type
      when 1
  			t '.message_payment_ogone_failed'
  		when 3
  			t '.message_payment_bank_transfer_failed'
  		when 2
  			t '.message_payment_dom_failed'
  		else
  			t '.unspecified'
  	end
  end
end