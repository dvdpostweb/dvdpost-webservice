class QuizzesController < ApplicationController
  def show
    @quizz_name = QuizzName.on_focus
    @previous_list = QuizzName.previous_list(4)
  end
  
  def create
    @contest = ContestName.find_by_contest_name_id(params[:contests][:contest_name_id])
    if @already_played.nil?
      contest = Contest.new(params[:contests])
      contest.customers_id = current_customer.to_param
      contest.language_id = DVDPost.product_languages[I18n.locale]
      contest.email = current_customer.email
      contest.pseudo = current_customer.first_name
      contest.marketing_ok = 'YES'
      contest.unsubscribe = true
      contest.date = Time.now.to_s(:db)
      if contest.save
        @contest = ContestName.find_by_contest_name_id(params[:contests][:contest_name_id])
      else
        render :action => :new
      end
    else
      @contest = ContestName.find_by_contest_name_id(params[:contests][:contest_name_id])
    end
  end
end
