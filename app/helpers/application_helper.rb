# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  protected
  def switch_locale_link(locale, options=nil)
    link_to I18n.t(locale, :scope => [:layouts, :header]), params.merge(:locale => locale), options
  end

  def product_media_id(media)
    case media
    when 'DVD', 'HDD', 'PS3', 'Wii' then media.downcase
    when 'BlueRay'                  then 'bluray'
    when 'XBOX 360'                 then 'xbox'
    else ''
    end
  end

  def list_indicator_class(value)
    case value
      when 0..10 then 'low'
      when 11..30 then 'medium'
      else 'high'
    end
  end

  def localized_image_tag(source, options={})
    image_tag File.join(I18n.locale.to_s, source), options
  end


  def oauth_client
    params = OAUTH.clone
    client_id = params.delete(:client_id)
    client_secret = params.delete(:client_secret)
    @client ||= OAuth2::Client.new(
      client_id, client_secret, params 
    )
  end

  def oauth_token
    session[:token] ? OAuth2::AccessToken.new(oauth_client, session[:oauth_token]) : nil
  end

  def sign_out_path
    "https://sso.dvdpost.dev/logout"
  end
end
