class SuspensionsController < ApplicationController
  def new
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def create
    
  end
end