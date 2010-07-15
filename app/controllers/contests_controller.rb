class ContestsController < ApplicationController

  def new
    @contest = ContestName.by_language(I18n.locale).by_date.ordered.first
    if @contest
      @already_played = current_customer.contests.find_by_contest_name_id(@contest.to_param)
    else
      @already_played = nil
    end
  end

  def create
    @contest = Contest.new(params[:contests])
    @contest.customers_id = current_customer.to_param
    @contest.language_id = DVDPost.product_languages[I18n.locale]
    @contest.email = current_customer.email
    @contest.pseudo = current_customer.first_name
    @contest.marketing_ok = 'YES'
    @contest.unsubscribe = true
    @contest.date = Time.now.to_s(:db)
    
    if @contest.save
      flash[:notice] = t('contests.new.success')
      redirect_to root_path
    else
      flash[:error] = t('contests.new.not_success')
      render :action => :new
    end
  end
end
