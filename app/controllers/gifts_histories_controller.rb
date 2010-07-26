class GiftsHistoriesController < ApplicationController
  def create
    points = params[:gifts_history][:points].to_i
    if current_customer.inviation_points >= points
      current_customer.update_attribute(:inviation_points, (current_customer.inviation_points - points))
      @gift_history = GiftsHistory.new(params[:gifts_history].merge(:customer => current_customer))
      if @gift_history.save
        flash[:notice] = t('sponsorships.show.gift_ready_to_send')
        redirect_to sponsorships_path
      else
        redirect_to sponsorships_gifts_history
      end
    else
      redirect_to sponsorships_path
    end
  end
end
