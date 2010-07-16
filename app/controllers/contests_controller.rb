class ContestsController < ApplicationController

  def index
    redirect_to new_contest_path
  end
  
  def new
    @contest = ContestName.by_language(I18n.locale).by_date.ordered.first
    if @contest
      @already_played = current_customer.contests.find_by_contest_name_id(@contest.to_param)
    else
      @already_played = nil
    end
  end

  def create
    @already_played = current_customer.contests.find_by_contest_name_id(params[:contests][:contest_name_id])
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
