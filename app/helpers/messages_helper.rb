module MessagesHelper
  def radio_question_for(form, attr)
    render :partial => 'messages/index/radio_question', :locals => {:f => form, :attr => attr}
  end

  def tab_item_class(tab, active)
    tab == active ? 'active' : ''
  end
end