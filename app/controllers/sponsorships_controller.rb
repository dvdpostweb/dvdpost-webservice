class SponsorshipsController < ApplicationController
  def show
    @free = current_customer.sponsorships.free.ordered.group_by_son
    @stop = current_customer.sponsorships.stop.ordered.group_by_son
    @ok = current_customer.sponsorships.ok.ordered.group_by_son

    @gifts_history= current_customer.gifts_history.ordered
    
    @current = "sponsor"
  end

  def gift
    @gifts = Gift.status.ordered
    @current = "gift"
  end

  def faq
    @current = "faq"
  end

  def more
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end
end
