class EmailVisionCustomer < ActiveRecord::Base
  
  def self.add_all
    #EmailVisionCustomer.destroy_all
    query = Customer.active.all
    query.each do |c|
      add(c)
    end
    return nil
  end
  def self.min_update
    puts "update_prospect"
    update_prospect
    puts "insert_new_data"
    insert_new_data
    puts "modify_abo_data"
    modify_abo_data
    puts "update_language"
    update_language
    puts "update_unsubscription"
    update_unsubscription
    puts "update_newsletters"
    update_newsletters
    puts "update_email"
    update_email
    puts "update_status"
    update_status
    puts "add_public_prospects"
    add_public_prospects
    
    puts "update_prospect_plush"
    update_prospect_plush
    puts "insert_new_data_plush"
    insert_new_data_plush
    puts "modify_abo_data_plush"
    modify_abo_data_plush
    puts "update_language_plush"
    update_language_plush
    puts "update_unsubscription_plush"
    update_unsubscription_plush
    puts "update_newsletters_plush"
    update_newsletters_plush
    puts "update_email_plush"
    update_email_plush
    puts "update_status_plush"
    update_status_plush
    puts "add_public_prospects_plush"
    add_public_prospects_plush
  end
  def self.update_all
    query = EmailVisionCustomer.find(:all, :conditions => ["source = 'DVDPOST' and email in ('henri.coremans@skynet.be','mariella.braccialini@skynet.be','dusepulchre_cedric@hotmail.com','barbara_beken@yahoo.com','Goitte@gmail.com','werner.vandeneede@telenet.be','colette.delvigne@dynaphar.be')"])
    query.each do |e|
      e.update_data
    end
    return nil
  end
  
  def self.insert_new_data
    sql = 'select customers_id from customers c
    left join email_vision_customers e on customers_id = customer_id and source ="DVDPOST"
    where email is null;'
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |h| 
      add(Customer.find(h['customers_id']))
    end
    return nil
  end

  def self.insert_new_data_plush
    sql = 'select customers_id from plush_'+(Rails.env == 'production' || Rails.env == 'pre_production' ? 'production': 'staging')+'.customers c
    left join email_vision_customers e on customers_id = customer_id and source ="PLUSH"
    where e.email is null;'
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |h| 
      add_plush(PlushCustomer.find(h['customers_id']))
    end
    return nil
  end

  def self.modify_abo_data
    query = EmailVisionCustomer.find_by_sql('select e.* from email_vision_customers e join customers c on customers_id = customer_id and source ="DVDPOST" where customers_abo != abo')
    query.each do |e| 
      e.update_data
    end
    return nil
  end

  def self.modify_abo_data_plush
    query = EmailVisionCustomer.find_by_sql('select e.* from email_vision_customers e join plush_'+(Rails.env == 'production' || Rails.env == 'pre_production' ? 'production': 'staging')+'.customers c on customers_id = customer_id and source ="PLUSH" where customers_abo != abo')
    query.each do |e| 
      e.update_data_plush
    end
    return nil
  end

  def self.update_language
    query = EmailVisionCustomer.find_by_sql('select e.* from email_vision_customers e join customers c on customers_id = customer_id and source ="DVDPOST" where customers_language != language_id')
    query.each do |e| 
      e.update_data
    end
    return nil
  end

  def self.update_language_plush
    query = EmailVisionCustomer.find_by_sql('select e.* from email_vision_customers e join plush_'+(Rails.env == 'production' || Rails.env == 'pre_production' ? 'production': 'staging')+'.customers c on customers_id = customer_id and source ="PLUSH" where customers_language != language_id')
    query.each do |e| 
      e.update_data_plush
    end
    return nil
  end

  def self.update_unsubscription
    sql = 'select e.id from customers c
    join email_vision_customers e on customers_id = customer_id and source ="DVDPOST"
    where customers_abo != abo;'
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |h| 
      email_vision = self.find(h['id'])
      email_vision.update_data
    end
    return nil
  end

  def self.update_email
    sql = 'select e.id from customers c
    join `email_vision_customers` e on e.customer_id = c.customers_id
    where email !=customers_email_address and source="dvdpost";'
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |h| 
      email_vision = self.find(h['id'])
      email_vision.update_data
    end
    return nil
  end
  def self.update_email_plush
    sql = 'select customer_id,  c.email ,e.email, client_type from plush_production.customers c
    join `email_vision_customers` e on e.customer_id = c.customers_id
    where c.email !=e.email and source="plush";'
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |h| 
      email_vision = self.find(h['id'])
      email_vision.update_data_plush
    end
    return nil
  end
  def self.update_unsubscription_plush
    sql = 'select e.id from plush_'+(Rails.env == 'production' || Rails.env == 'pre_production' ? 'production': 'staging')+'.customers c
    join email_vision_customers e on customers_id = customer_id and source ="PLUSH"
    where customers_abo != abo;'
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |h| 
      email_vision = self.find(h['id'])
      email_vision.update_data_plush
    end
    return nil
  end

  def self.update_newsletters
    sql = 'select e.id from customers c
    join email_vision_customers e on customers_id = customer_id and source ="DVDPOST"
    where customers_newsletter != newsletters;'
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |h| 
      email_vision = self.find(h['id'])
      email_vision.update_data
    end
    return nil
  end

  def self.update_newsletters_plush
    sql = 'select e.id from plush_'+(Rails.env == 'production' || Rails.env == 'pre_production' ? 'production': 'staging')+'.customers c
    join email_vision_customers e on customers_id = customer_id and source ="PLUSH"
    where customers_newsletter != newsletters;'
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |h| 
      email_vision = self.find(h['id'])
      email_vision.update_data_plush
    end
    return nil
  end

  def self.update_category
      EmailVisionCustomer.find(:all, :conditions => ["customer_id > 0 and source = 'dvdpost' "]).each do |c|
      sql = "select IFNULL(categories_id,0) cat from (select c.categories_id from (select product_id from wishlist where customers_id = #{c.customer_id}
      union
      select products_id product_id from wishlist_assigned where customers_id =#{c.customer_id}
      union
      select p.products_id from tokens t 
      join products p on t.imdb_id = p.imdb_id where customer_id = #{c.customer_id}
      group by p.imdb_id ) p
      join products_to_categories c on p.product_id = c.products_id
      join categories ca on ca.categories_id = c.categories_id
      where parent_id = 0
      group by categories_id
      order by count(*) desc limit 1)t"
      results = ActiveRecord::Base.connection.execute(sql)
      if data = results.fetch_row
        rental_cat = data.first
        c.update_attribute(:rental_cat, rental_cat)
      end
    end
  end
  def self.update_prospect
    sql = 'select e.id, c.customers_id from `email_vision_customers` e
    join customers c on e.email = c.customers_email_address and source ="DVDPOST"
    where client_type="prospet" or client_type="public"';
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |h| 
      email_vision = self.find(h['id'])
      email_vision.update_attributes(:customer_id => h['customers_id'])
      email_vision.update_data
    end
    return nil
  end

  def self.update_prospect_plush
    sql = 'select e.id, c.customers_id from `email_vision_customers` e
    join plush_'+(Rails.env == 'production' || Rails.env == 'pre_production' ? 'production': 'staging')+'.customers c on e.email = c.email and source ="PLUSH"
    where client_type="public" or client_type="prospet"';
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |h| 
      email_vision = self.find(h['id'])
      email_vision.update_attributes(:customer_id => h['customers_id'])
      email_vision.update_data_plush
    end
    return nil
  end
  
  def self.update_status
    sql ='select e.* from email_vision_customers e join customers c on c.customers_id = e.customer_id and customers_abo=1 and source ="DVDPOST"'
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |e|
      email_vision = self.find(e['id'])
      email_vision.update_data
    end
    return nil
  end
      
  def self.update_status_plush
    sql ='select e.* from email_vision_customers e join plush_'+(Rails.env == 'production' || Rails.env == 'pre_production' ? 'production': 'staging')+'.customers c on c.customers_id = e.customer_id and customers_abo=1 and source ="PLUSH"'
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |e|
      email_vision = self.find(e['id'])
      email_vision.update_data_plush
    end
    return nil
  end
      

  def update_data
    c = Customer.find_by_customers_id(self.customer_id)
    if c
      nb_recondution = 0
      client_type = 
      if c.abo_active == 1
        sql2 = "select count(*) nb from abo where customerid = #{c.to_param} and action = 7 and abo_id > (select abo_id from abo where `customerid`= #{c.to_param} and action in (6,8,1) order by abo_id desc limit 1)"
        results_free = ActiveRecord::Base.connection.execute(sql2)
        nb_recondution = results_free.fetch_row.first
        if nb_recondution.to_i > 0
          "payed"
        else
          "freetest"
        end
      else
        if c.step == 90
          "old"
        elsif c.step == 80
          "shop"
        else
          "step"
        end
      end
      attribute = c.customer_attribute
      if attribute
        newsx = attribute.newsletters_x
        last_log = attribute.last_login_at
        vod_only = attribute.only_vod
      else
        newsx = 0
        last_log = nil
        vod_only = 0
      end
      news = c.customers_newsletter
      news_partners = c.customers_newsletterpartner
      
      count_vod = c.tokens.count
      address = c.address
      vod_at = nil
      #vod_at = 
      #if count_vod > 0
      #  c.tokens.last.created_at.to_s(:db)
      #else
      #  nil
      #end
      payment_type = 
      case c.customers_abo_payment_method 
        when 1
          "ogone"
        when 2
          "domiciliation"
        when 3
          "bank_account"
      end
      if c.birthday
        birth = c.birthday.strftime('%Y-%m-%d')
      else
        birth = nil
      end
      next_reconduction_at = c.subscription_expiration_date ? c.subscription_expiration_date.to_s(:db) : nil
      #if client_type == "payed_customer" || client_type == "freetest_customer"
      #  sql = "select IFNULL(group_concat(categories_id),0) cat from (select categories_id from (select product_id from wishlist where customers_id = #{c.to_param}
      #  union
      #  select products_id product_id from wishlist_assigned where customers_id =#{c.to_param}
      #  union
      #  select p.products_id from tokens t 
      #  join products p on t.imdb_id = p.imdb_id where customer_id = #{c.to_param}
      #  group by p.imdb_id ) p
      #  join products_to_categories c on p.product_id = c.products_id
      #  group by categories_id
      #  order by count(*) desc limit 3)t"
      #  results = ActiveRecord::Base.connection.execute(sql)
      #  rental_cat = results.fetch_row.first
      #else
      #  rental_cat = 0
      #end
      #rental_cat = 0
      last_dvd_at = nil
      #last_dvd_at = c.assigned_items.count > 0 ? c.assigned_items.last.date_assigned.to_s(:db) : nil
      vod_habit = 
      if vod_only
        "vod_only"
      else
        if count_vod == 0
          "no_vod"
        elsif count_vod < 10
          "small_vod"
        else
          "normal_vod"
        end
      end
    
      if address
        street = address.street
        postal_code = address.postal_code
        country = address.country ? address.country.name : nil
      else
        street = nil
        postal_code = nil
        country = nil
      end
      self.update_attributes(:phone => c.phone.gsub(/[^0-9]/,''), :email => c.email, :firstname => c.first_name, :lastname => c.last_name, :client_type => client_type, :language_id => c.language, :gender => c.gender, :vod_habit => vod_habit, :nb_vod_views => count_vod, :birthday => birth, :last_login_at => last_log, :street => street, :postal_code => postal_code, :country => country, :suspended => c.suspension_status, :abo => c.abo_active, :abo_type => c.abo_type_id, :size_wl_dvd => c.wishlist_items.count, :size_wl_dvd_assigned => c.assigned_items.count, :size_wl_vod => c.vod_wishlists.count, :cpt_reconduction => nb_recondution, :cpt_reconduction_all => c.actions.count, :auto_stop => c.auto_stop, :next_reconduction_at => next_reconduction_at, :last_vod_view_at => vod_at, :last_post_send_at => last_dvd_at, :cpt_payment_recovery => 0, :blacklisted => c.black_listed, :sleep => c.sleep, :payment_type => payment_type, :newsletters_adult => newsx, :newsletters => news, :newsletters_partners => news_partners)
    else
      puts "error customer #{self.customer_id}"
    end
  end

  def update_data_plush
    c = PlushCustomer.find_by_customers_id(self.customer_id)
    if c
      nb_recondution = 0
      client_type = 
      if c.abo_active == 1
        sql2 = "select count(*) nb from plush_#{Rails.env == 'production' || Rails.env == 'pre_production' ? 'production': 'staging'}.abo where customerid = #{c.to_param} and action = 7 and abo_id > (select (abo_id-2) from plush_#{Rails.env == 'production' || Rails.env == 'pre_production' ? 'production': 'staging'}.abo where `customerid`= #{c.to_param} and action in (6,8,1) order by abo_id desc limit 1)"
        results_free = ActiveRecord::Base.connection.execute(sql2)
        nb_recondution = results_free.fetch_row.first
        if nb_recondution.to_i > 0
          "payed"
        else
          "freetest"
        end
      else
        if c.step == 90
          "old"
        elsif c.step == 80
          "shop"
        else
          "step"
        end
      end
      newsx = 0
      if c.current_sign_in_at
        last_log = c.current_sign_in_at.strftime('%Y-%m-%d 00:00:00')
      else
        last_log = nil
      end
      vod_only = 1
      news = c.customers_newsletter
      news_partners = c.customers_newsletterpartner
      count_vod = c.plush_tokens.count
      address = c.plush_address
      vod_at = nil
      #vod_at = 
      #if count_vod > 0
      #  c.tokens.last.created_at.to_s(:db)
      #else
      #  nil
      #end
      if c.birthday
        birth = c.birthday.strftime('%Y-%m-%d')
      else
        birth = nil
      end
      payment_type = 
      case c.customers_abo_payment_method 
        when 1
          "ogone"
        when 2
          "domiciliation"
        when 3
          "bank_account"
      end
      next_reconduction_at = c.subscription_expiration_date ? c.subscription_expiration_date.to_s(:db) : nil
      #if client_type == "payed_customer" || client_type == "freetest_customer"
      #  sql = "select IFNULL(group_concat(categories_id),0) cat from (select categories_id from (select product_id from wishlist where customers_id = #{c.to_param}
      #  union
      #  select products_id product_id from wishlist_assigned where customers_id =#{c.to_param}
      #  union
      #  select p.products_id from tokens t 
      #  join products p on t.imdb_id = p.imdb_id where customer_id = #{c.to_param}
      #  group by p.imdb_id ) p
      #  join products_to_categories c on p.product_id = c.products_id
      #  group by categories_id
      #  order by count(*) desc limit 3)t"
      #  results = ActiveRecord::Base.connection.execute(sql)
      #  rental_cat = results.fetch_row.first
      #else
      #  rental_cat = 0
      #end
      #rental_cat = 0
      last_dvd_at = nil
      #last_dvd_at = c.assigned_items.count > 0 ? c.assigned_items.last.date_assigned.to_s(:db) : nil
      vod_habit = 
      if vod_only
        "vod_only"
      else
        if count_vod == 0
          "no_vod"
        elsif count_vod < 10
          "small_vod"
        else
          "normal_vod"
        end
      end
    
      if address
        street = address.street
        postal_code = address.postal_code
        country = address.country ? address.country.name : nil
      else
        street = nil
        postal_code = nil
        country = nil
      end
      self.update_attributes(:phone => c.phone.gsub(/[^0-9]/,''), :email => c.email, :firstname => c.first_name, :lastname => c.last_name, :client_type => client_type, :language_id => c.language, :gender => c.gender, :vod_habit => vod_habit, :nb_vod_views => count_vod, :birthday => birth, :last_login_at => last_log, :street => street, :postal_code => postal_code, :country => country, :suspended => c.suspension_status, :abo => c.abo_active, :abo_type => c.abo_type_id, :size_wl_dvd => 0, :size_wl_dvd_assigned => 0, :size_wl_vod => c.plush_vod_wishlists.count, :cpt_reconduction => nb_recondution, :cpt_reconduction_all => c.plush_actions.count, :auto_stop => c.auto_stop, :next_reconduction_at => next_reconduction_at, :last_vod_view_at => vod_at, :last_post_send_at => last_dvd_at, :cpt_payment_recovery => 0, :blacklisted => 0, :sleep => c.sleep, :payment_type => payment_type, :newsletters_adult => newsx, :newsletters => news, :newsletters_partners => news_partners)
    else
      puts "error customer #{self.customer_id}"
    end
  end

  def self.add_plush(c)
    nb_recondution = 0
    client_type = 
    if c.abo_active == 1
      sql2 = "select count(*)nb from plush_#{Rails.env == 'production' || Rails.env == 'pre_production' ? 'production': 'staging'}.abo where customerid = #{c.to_param} and action = 7 and abo_id > (select (abo_id-2) from plush_#{Rails.env == 'production' || Rails.env == 'pre_production' ? 'production': 'staging'}.abo where `customerid`= #{c.to_param} and action in (6,8,1) order by abo_id desc limit 1)"
      results_free = ActiveRecord::Base.connection.execute(sql2)
      nb_recondution = results_free.fetch_row.first
      if nb_recondution.to_i > 0
        "payed"
      else
        "freetest"
      end
    else
      if c.step == 90
        "old"
      elsif c.step == 80
        "shop"
      else
        "step"
      end
    end
    newsx = 0
    news = c.customers_newsletter
    news_partners = c.customers_newsletterpartner
    if c.current_sign_in_at
      last_log = c.current_sign_in_at.strftime('%Y-%m-%d') 
    else
      last_log = nil
    end
    vod_only = 1
    count_vod = c.plush_tokens.count
    address = c.plush_address
    vod_at = nil
    #vod_at = 
    #if count_vod > 0
    #  c.tokens.last.created_at.to_s(:db)
    #else
    #  nil
    #end
    payment_type = 
    case c.customers_abo_payment_method 
      when 1
        "ogone"
      when 2
        "domiciliation"
      when 3
        "bank_account"
    end
    next_reconduction_at = c.subscription_expiration_date ? c.subscription_expiration_date.to_s(:db) : nil
    #if client_type == "payed_customer" || client_type == "freetest_customer"
    #  sql = "select IFNULL(group_concat(categories_id),0) cat from (select categories_id from (select product_id from wishlist where customers_id = #{c.to_param}
    #  union
    #  select products_id product_id from wishlist_assigned where customers_id =#{c.to_param}
    #  union
    #  select p.products_id from tokens t 
    #  join products p on t.imdb_id = p.imdb_id where customer_id = #{c.to_param}
    #  group by p.imdb_id ) p
    #  join products_to_categories c on p.product_id = c.products_id
    #  group by categories_id
    #  order by count(*) desc limit 3)t"
    #  results = ActiveRecord::Base.connection.execute(sql)
    #  rental_cat = results.fetch_row.first
    #else
    #  rental_cat = 0
    #end
    #rental_cat = 0
    last_dvd_at = nil
    #last_dvd_at = c.assigned_items.count > 0 ? c.assigned_items.last.date_assigned.to_s(:db) : nil
    vod_habit = 
    if vod_only
      "vod_only"
    else
      if count_vod == 0
        "no_vod"
      elsif count_vod < 10
        "small_vod"
      else
        "normal_vod"
      end
    end
    
    if address
      street = address.street
      postal_code = address.postal_code
      country = address.country ? address.country.name : nil
    else
      street = nil
      postal_code = nil
      country = nil
    end
    EmailVisionCustomer.create(:customer_id => c.to_param,:phone => c.phone.gsub(/[^0-9]/,''), :email => c.email, :firstname => c.first_name, :lastname => c.last_name, :client_type => client_type, :language_id => c.language, :gender => c.gender, :vod_habit => vod_habit, :nb_vod_views => count_vod, :birthday => c.birthday, :last_login_at => last_log, :street => street, :postal_code => postal_code, :country => country, :suspended => c.suspension_status, :abo => c.abo_active, :abo_type => c.abo_type_id, :size_wl_dvd => 0, :size_wl_dvd_assigned => 0, :size_wl_vod => c.plush_vod_wishlists.count, :cpt_reconduction => nb_recondution, :cpt_reconduction_all => c.plush_actions.count, :auto_stop => c.auto_stop, :next_reconduction_at => next_reconduction_at, :last_vod_view_at => vod_at, :last_post_send_at => last_dvd_at, :cpt_payment_recovery => 0, :blacklisted => 0, :sleep => c.sleep, :payment_type => payment_type, :newsletters_adult => newsx, :newsletters => news, :newsletters_partners => news_partners, :source => 'PLUSH')
  end

  def self.add(c)
    nb_recondution = 0
    client_type = 
    if c.abo_active == 1
      sql2 = "select count(*)nb from abo where customerid = #{c.to_param} and action = 7 and abo_id > (select abo_id from abo where `customerid`= #{c.to_param} and action in (6,8,1) order by abo_id desc limit 1)"
      results_free = ActiveRecord::Base.connection.execute(sql2)
      nb_recondution = results_free.fetch_row.first
      if nb_recondution.to_i > 0
        "payed"
      else
        "freetest"
      end
    else
      if c.step == 90
        "old"
      elsif c.step == 80
        "shop"
      else
        "step"
      end
    end
    attribute = c.customer_attribute
    newsx = attribute.newsletters_x
    news = c.customers_newsletter
    news_partners = c.customers_newsletterpartner
    last_log = attribute.last_login_at
    vod_only = attribute.only_vod
    count_vod = c.tokens.count
    address = c.address
    vod_at = nil
    #vod_at = 
    #if count_vod > 0
    #  c.tokens.last.created_at.to_s(:db)
    #else
    #  nil
    #end
    payment_type = 
    case c.customers_abo_payment_method 
      when 1
        "ogone"
      when 2
        "domiciliation"
      when 3
        "bank_account"
    end
    next_reconduction_at = c.subscription_expiration_date ? c.subscription_expiration_date.to_s(:db) : nil
    #if client_type == "payed_customer" || client_type == "freetest_customer"
    #  sql = "select IFNULL(group_concat(categories_id),0) cat from (select categories_id from (select product_id from wishlist where customers_id = #{c.to_param}
    #  union
    #  select products_id product_id from wishlist_assigned where customers_id =#{c.to_param}
    #  union
    #  select p.products_id from tokens t 
    #  join products p on t.imdb_id = p.imdb_id where customer_id = #{c.to_param}
    #  group by p.imdb_id ) p
    #  join products_to_categories c on p.product_id = c.products_id
    #  group by categories_id
    #  order by count(*) desc limit 3)t"
    #  results = ActiveRecord::Base.connection.execute(sql)
    #  rental_cat = results.fetch_row.first
    #else
    #  rental_cat = 0
    #end
    #rental_cat = 0
    last_dvd_at = nil
    #last_dvd_at = c.assigned_items.count > 0 ? c.assigned_items.last.date_assigned.to_s(:db) : nil
    vod_habit = 
    if vod_only
      "vod_only"
    else
      if count_vod == 0
        "no_vod"
      elsif count_vod < 10
        "small_vod"
      else
        "normal_vod"
      end
    end
    
    if address
      street = address.street
      postal_code = address.postal_code
      country = address.country ? address.country.name : nil
    else
      street = nil
      postal_code = nil
      country = nil
    end
    EmailVisionCustomer.create(:customer_id => c.to_param,:phone => c.phone.gsub(/[^0-9]/,''), :email => c.email, :firstname => c.first_name, :lastname => c.last_name, :client_type => client_type, :language_id => c.language, :gender => c.gender, :vod_habit => vod_habit, :nb_vod_views => count_vod, :birthday => c.birthday, :last_login_at => last_log, :street => street, :postal_code => postal_code, :country => country, :suspended => c.suspension_status, :abo => c.abo_active, :abo_type => c.abo_type_id, :size_wl_dvd => c.wishlist_items.count, :size_wl_dvd_assigned => c.assigned_items.count, :size_wl_vod => c.vod_wishlists.count, :cpt_reconduction => nb_recondution, :cpt_reconduction_all => c.actions.count, :auto_stop => c.auto_stop, :next_reconduction_at => next_reconduction_at, :last_vod_view_at => vod_at, :last_post_send_at => last_dvd_at, :cpt_payment_recovery => 0, :blacklisted => c.black_listed, :sleep => c.sleep, :payment_type => payment_type, :newsletters_adult => newsx, :newsletters => news, :newsletters_partners => news_partners)
  end

  def self.add_public_prospects
    sql = 'select public_newsletters.* from public_newsletters
        left join customers on public_newsletters.email = `customers_email_address`
        left join `email_vision_customers` on email_vision_customers.email = public_newsletters.email and source ="DVDPOST"
        where customers_email_address is null and email_vision_customers.email is null group by public_newsletters.email'
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |h|
      EmailVisionCustomer.create( :email => h['email'], :client_type => 'public', :language_id => h['language_id'], :newsletters_partners => 0)
    end
  
  end

  def self.add_public_prospects_plush
    sql = 'select public_newsletters.* from plush_'+(Rails.env == 'production' || Rails.env == 'pre_production' ? 'production': 'staging')+'.public_newsletters
        left join plush_'+(Rails.env == 'production' || Rails.env == 'pre_production' ? 'production': 'staging')+'.customers on public_newsletters.email = customers.email
        left join `email_vision_customers` on email_vision_customers.email = public_newsletters.email and source ="PLUSH"
        where customers.email is null and email_vision_customers.email is null group by public_newsletters.email'
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |h|
      EmailVisionCustomer.create( :email => h['email'], :client_type => 'public', :language_id => h['language_id'], :newsletters_partners => 0, :source => 'PLUSH')
    end
  
  end
  def self.add_prospects_plush
    sql = 'select prospects.* from plush_production.prospects
            left join plush_production.customers on prospects.email = customers.email
            left join `email_vision_customers` on email_vision_customers.email = prospects.email and source ="PLUSH"
            where customers.email is null and email_vision_customers.email is null group by prospects.email'
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |h|
      EmailVisionCustomer.create( :email => h['email'], :client_type => 'prospet', :language_id => h['locale_id'], :gender => h['gender'].downcase , :newsletters => h['newsletters'], :newsletters_partners => h['newsletters_partners'], :source => 'PLUSH')
    end
  
  end
end