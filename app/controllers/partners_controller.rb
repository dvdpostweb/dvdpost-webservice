class PartnersController < ApplicationController
  before_filter :http_authenticate

  def index
    @partners = Partner.all
  end

  def new
    @partner = Partner.new
  end

  def edit
    @partner = Partner.find(params[:id])
  end

  def create
    @partner = Partner.new(params[:partner])
    if @partner.save
      flash[:notice] = 'Partner was successfully created.'
      redirect_to partners_path
    else
      render :action => :new
    end
  end

  def update
    @partner = Partner.find(params[:id])
    if @partner.update_attributes(params[:partner])
      flash[:notice] = 'Partner was successfully updated.'
      redirect_to partners_path
    else
      render :action => :edit
    end
  end

  def destroy
    @partner = Partner.find(params[:id])
    @partner.destroy
    redirect_to partners_path
  end

end
