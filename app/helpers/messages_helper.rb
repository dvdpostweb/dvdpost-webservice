module MessagesHelper
  def radio_question_for(form, attr, id)
    render :partial => 'messages/index/radio_question', :locals => {:f => form, :attr => attr, :id => id}
  end

  def tab_item_class(tab, active)
    tab == active ? 'active' : ''
  end

  def offline_reason(reason)
    case reason
      when 'OGONE'
  			t '.message_payment_ogone_failed'
  		when 'BANK_TRANSFER'
  			t '.message_payment_bank_transfer_failed'
  		when 'DOMICILIATION', 'domiciliation_payment_id'
  			t '.message_payment_dom_failed'
  		when 'abo_stopped_with_dvdathome_id'
  			t '.message_payment_abo_stopped_dvd_at_home'
  		else
  			t '.unspecified'
  	end
  end
end