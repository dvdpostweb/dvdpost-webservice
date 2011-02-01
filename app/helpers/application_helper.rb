# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  protected
  def switch_locale_link(locale, options=nil)
    link_to t(".#{locale}"), params.merge(:locale => locale), options
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
      when 0..9 then 'low'
      when 10..29 then 'medium'
      else 'high'
    end
  end

  def redirect_after_registration
    if current_customer && current_customer.customers_registration_step.to_i != 100  && current_customer.customers_registration_step.to_i != 95
      redirect_to php_path
    end
  end

  def localized_image_tag(source, options={})
    image_tag File.join(I18n.locale.to_s, source), options
  end

  def save_attempted_path
    session[:attempted_path] = request.request_uri
  end

  def wishlist_size
    @wishlist_size = (current_customer.wishlist_items.available.by_kind(:normal).current.include_products.count || 0) if current_customer
  end

  def delegate_locale
    if params[:locale].nil?
      set_locale('fr')
    else
      set_locale(params[:locale])
    end
  end

  def messages_size
    @messages_size = (current_customer.messages.not_read.count || 0) if current_customer
  end

  def load_partners
    @partners = Partner.active.by_language(I18n.locale).ordered
  end

  def current_customer
    current_user
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
    session[:oauth_token] ? OAuth2::AccessToken.new(oauth_client, session[:oauth_token]) : nil
  end

  def redirect_url_after_sign_out
    php_path
  end

  def blog_url
    "http://insidedvdpost.blogspot.com/"
  end

  def fb_url
    "http://www.facebook.com/s.php?q=20460859834&sid=4587e86f26b471cb22ab4b18b3ec5047#/group.php?sid=4587e86f26b471cb22ab4b18b3ec5047&gid=20460859834"
  end

  def twitter_url
    "http://twitter.com/dvdpost"
  end

  def vimeo_url
    "http://vimeo.com/5199678"
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def parent_layout(layout)
    @content_for_layout = self.output_buffer
    self.output_buffer = render(:file => "layouts/#{layout}")
  end

  def php_path(path=nil)
    country_id = current_customer && current_customer.addresses ? current_customer.addresses.first.entry_country_id : nil
    host = case  Rails.env
      when 'development'
        'http://localhost/'
      when 'staging'
        'http://test/'
      else
        production_path(country_id)
    end
    result = "#{host}#{path}"
    "#{result}#{result.include?('?') ? '&' : '?'}language=#{I18n.locale}"
  end

  def limited_subscription_change_path
    php_path 'subscription_change_limited.php'
  end

  def product_shop_path(product)
    php_path "product_info_shop.php?products_id=#{product.to_param}"
  end

  def payment_method_change_path(type=nil)
    path = php_path 'payment_method_change.php'
    type ? "#{path}&payment=#{type}" : path
  end

  def adult_path
    php_path 'mydvdxpost.php'
  end

  def my_shop_path
    php_path 'mydvdshop.php'
  end

  def remote_carousel_path(carousel)
    php_path carousel
  end

  def shop_path(url)
    php_path url
  end

  def production_path(country_id=nil)
    if country_id.to_i == 21 || country_id.to_i == 124 || country_id == nil
      'http://www.dvdpost.be/'
    else
      'http://www.dvdpost.nl/'
    end
  end

  def product_assigned_path(product)
    if product
      if product.products_type == DVDPost.product_kinds[:adult]
        php_path "product_info_adult.php?products_id=#{product.to_param}"
      else
        product_path(:id => product.to_param)
      end
    end
  end

  def product_assigned_title(product)
    if product
      if product.products_type == DVDPost.product_kinds[:adult]
        t('wishlit_items.index.adult_title')
      else
        product.title
      end
    else
      ''
    end
  end

  def email_data_replace(text,options)
    options.each {|key, value| 
      r = Regexp.new(key, true)
      text = text.gsub(r, value)
    }
    text
  end

  def distance_of_time_in_hours(from_time,to_time)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_hours = (((to_time - from_time).abs)/3600)
    if(distance_in_hours<1)
      "#{(((to_time - from_time).abs)/60).round} #{t('time.minutes')}"
    else
      distance_in_hours = distance_in_hours.round
      "#{distance_in_hours} #{distance_in_hours == 1 ? t('time.hour') : t('time.hours')}"
    end
  end

  def time_left(stream)
    distance_of_time_in_hours((stream.updated_at + 48.hours), Time.now)
  end

  def streaming_access?
    current_customer.address.belgian? && (session[:country_code] == 'BE' || session[:country_code] == 'RD')
  end

  def display_btn_tops
    if session[:menu_tops] == true
      type = 'close'
      css_class = 'active'
    else
      type = 'open'
      css_class = ''
    end
    link_to t('.tops'), menu_tops_path(:type => type), :id => :tops, :class => css_class
  end
  
  def display_btn_categories
    if session[:menu_categories] == true || session[:menu_categories] == nil
      type = 'close'
      css_class = 'active'
    else
      type = 'open'
      css_class = ''
    end
    link_to t('.categories'), menu_categories_path(:type => type), :id => :categories, :class => css_class
  end

  def set_title(alter_title, replace = true)
    if alter_title.blank?
      @title = t '.title'
    else
      if replace
        @title = alter_title
      else
        @title = "#{t '.title'} - #{alter_title}"
      end
    end
  end
  require 'rexml/parsers/pullparser.rb'
  def truncate_html2(input, len = 30, extension = "...")  
    def attrs_to_s(attrs)  
      return '' if attrs.empty?  
      attrs.to_a.map { |attr| %{#{attr[0]}="#{attr[1]}"} }.join(' ')  
    end  
    
    p = REXML::Parsers::PullParser.new(input)  
      tags = []  
      new_len = len  
      results = ''  
      while p.has_next? && new_len > 0  
        p_e = p.pull  
        case p_e.event_type  
      when :start_element  
        tags.push p_e[0]  
        results << "<#{tags.last} #{attrs_to_s(p_e[1])}>"  
      when :end_element  
        results << "</#{tags.pop}>"  
      when :text  
        results << p_e[0].first(new_len)  
        new_len -= p_e[0].length  
      else  
        results << "<!-- #{p_e.inspect} -->"  
      end  
    end  
    
    tags.reverse.each do |tag|  
      results << "</#{tag}>"  
    end  
    
    results.to_s + (input.length > len ? extension : '')  
  end

  def streaming_btn_title(type, text)
    if(type == :replay)
      text == :short ? t('.replay_short') : t('.replay')
    else
      text == :short ? t('.buy_short') : t('.buy')
    end
  end

  def sort_collection_for_select
    options = []
    codes_hash = Product.list_sort
    codes_hash.each {|key, code| options.push [t(".#{key}"), key]}
    options
  end

end