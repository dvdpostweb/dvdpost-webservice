module MessagesHelper
  def radio_question_for(form, attr, id)
    render :partial => 'messages/index/radio_question', :locals => {:f => form, :attr => attr, :id => id}
  end

  def tab_item_class(tab, active)
    tab == active ? 'active' : ''
  end
end