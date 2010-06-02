class LocalesController < ApplicationController
  layout 'translator'

  def index
    @locales = Locale.all(:order => 'iso')
  end

  def show
    @locale = Locale.find(params[:id])
  end

  def new
    @locale = Locale.new
  end

  def edit
    @locale = Locale.find(params[:id])
  end

  def create
    @locale = Locale.new(params[:locale])
    if @locale.save
      flash[:notice] = 'Locale was successfully created.'
      redirect_to locales_path
    else
      render :action => :new
    end
  end

  def update
    @locale = Locale.find(params[:id])
    if @locale.update_attributes(params[:locale])
      flash[:notice] = 'Locale was successfully updated.'
      redirect_to locales_path 
    else
      render :action => :edit
    end
  end

  def destroy
    @locale = Locale.destroy(params[:id])
    redirect_to locales_path
  end

  def reload
    locale = Locale.find(params[:id])
    raise "wrong locale" unless locale
    locale.short_will_change! # any field in fact, we just need to bump the updated_at attribute
    locale.save!
    
    Locale.uncached do
      locale = Locale.find(params[:id])
      Rails.cache.write("locale_versions/#{locale.short}", locale.updated_at)
    end    

    ## Expire all the caches that you made that depend on this locale
    # expire_fragment "base-menu-loggedin-#{locale.short}"
    ## ...

    flash[:notice] = 'Locale was successfully reloaded.'
    redirect_to locales_path
  end
end
