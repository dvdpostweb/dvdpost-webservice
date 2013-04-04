class EmailVisionCustomer < ActiveRecord::Base
  belongs_to :customer
  def self.add_all
    #EmailVisionCustomer.destroy_all
    query = Customer.active.all
    query.each do |c|
      add(c)
    end
    return nil
  end

  def self.update_all
    query = EmailVisionCustomer.find(:all, :conditions => ["email in ('henri.coremans@skynet.be','mariella.braccialini@skynet.be','dusepulchre_cedric@hotmail.com','barbara_beken@yahoo.com','Goitte@gmail.com','werner.vandeneede@telenet.be','colette.delvigne@dynaphar.be')"])
    query.each do |e|
      e.update_data
    end
    return nil
  end
  
  def self.insert_new_data
    sql = 'select customers_id from customers c
    left join email_vision_customers e on customers_id = customer_id
    where email is null;'
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |h| 
      add(Customer.find(h['customers_id']))
    end
  end

  def self.modify_abo_data
    query = EmailVisionCustomer.find_by_sql('select e.* from email_vision_customers e join customers c on customers_id = customer_id where customers_abo != abo')
    query.each do |e| 
      e.update_data
    end
  end

  def self.update_language
    query = EmailVisionCustomer.find_by_sql('select e.* from email_vision_customers e join customers c on customers_id = customer_id where customers_language != language_id')
    query.each do |e| 
      e.update_data
    end
  end

  def self.update_unsubscription
    sql = 'select customers_id from customers c
    join email_vision_customers e on customers_id = customer_id
    where customers_abo != abo;'
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |h| 
      email_vision = self.find_by_customer_id(h['customers_id'])
      email_vision.update_data
    end
  end
  def self.update_newsletters
    sql = 'select customers_id from customers c
    join email_vision_customers e on customers_id = customer_id
    where customers_newsletter != newsletters;'
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |h| 
      email_vision = self.find_by_customer_id(h['customers_id'])
      email_vision.update_data
    end
  end

  def self.update_category
      EmailVisionCustomer.find(:all, :conditions => ["client_type != 'prospet' and client_type != 'step' and updated_at > '2013-02-08'"]).each do |c|
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
    join customers c on e.email = c.customers_email_address
    where client_type="prospet"';
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |h| 
      email_vision = self.find(h['id'])
      email_vision.update_attributes(:customer_id => h['customers_id'])
      email_vision.update_data
    end
    
  end
  
  def self.update_status
    EmailVisionCustomer.find(:all, :include => [:customer => :customer_attribute], :conditions => { :customers => {:customers_abo => 1}}).collect do |e|
      if e.customer.customers_id > 0
        client_type = nil
        if e.customer.abo_active == 1
          sql2 = "select count(*) nb from abo where customerid = #{e.customer_id} and action = 7 and abo_id > (select abo_id from abo where `customerid`= #{e.customer_id} and action in (6,8,1) order by abo_id desc limit 1)"
          results_free = ActiveRecord::Base.connection.execute(sql2)
          nb_recondution = results_free.fetch_row.first
          if nb_recondution.to_i > 0
            client_type = "payed"
          else
            client_type = "freetest"
          end
        else
          if e.customer.step == 90
            client_type = "old"
          elsif e.customer.step == 80
            client_type = "shop"
          else
            client_type = "step"
          end
        end
        if !client_type.nil?
          e.update_attributes(:client_type => client_type, :suspended => e.customer.suspension_status, :abo => e.customer.abo_active, :newsletters => e.customer.newsletter, :newsletters_adult => e.customer.customer_attribute.newsletters_x)
        end
      end
      
      
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
      rental_cat = 0
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
      self.update_attributes(:phone => c.phone.gsub(/[^0-9]/,''), :email => c.email, :firstname => c.first_name, :lastname => c.last_name, :client_type => client_type, :language_id => c.language, :gender => c.gender, :vod_habit => vod_habit, :nb_vod_views => count_vod, :birthday => c.birthday, :last_login_at => last_log, :street => street, :postal_code => postal_code, :country => country, :suspended => c.suspension_status, :abo => c.abo_active, :abo_type => c.abo_type_id, :size_wl_dvd => c.wishlist_items.count, :size_wl_dvd_assigned => c.assigned_items.count, :size_wl_vod => c.vod_wishlists.count, :cpt_reconduction => nb_recondution, :cpt_reconduction_all => c.actions.count, :auto_stop => c.auto_stop, :next_reconduction_at => next_reconduction_at, :last_vod_view_at => vod_at, :last_post_send_at => last_dvd_at, :cpt_payment_recovery => 0, :blacklisted => c.black_listed, :sleep => c.sleep, :payment_type => payment_type, :newsletters_adult => newsx, :newsletters => news)
    else
      puts "error customer #{self.customer_id}"
    end
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
    rental_cat = 0
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
    EmailVisionCustomer.create(:customer_id => c.to_param,:phone => c.phone.gsub(/[^0-9]/,''), :email => c.email, :firstname => c.first_name, :lastname => c.last_name, :client_type => client_type, :language_id => c.language, :gender => c.gender, :vod_habit => vod_habit, :nb_vod_views => count_vod, :birthday => c.birthday, :rental_cat => rental_cat, :last_login_at => last_log, :street => street, :postal_code => postal_code, :country => country, :suspended => c.suspension_status, :abo => c.abo_active, :abo_type => c.abo_type_id, :size_wl_dvd => c.wishlist_items.count, :size_wl_dvd_assigned => c.assigned_items.count, :size_wl_vod => c.vod_wishlists.count, :cpt_reconduction => nb_recondution, :cpt_reconduction_all => c.actions.count, :auto_stop => c.auto_stop, :next_reconduction_at => next_reconduction_at, :last_vod_view_at => vod_at, :last_post_send_at => last_dvd_at, :cpt_payment_recovery => 0, :blacklisted => c.black_listed, :sleep => c.sleep, :payment_type => payment_type, :newsletters_adult => newsx, :newsletters => news)
  end

  def self.add_public_prospects
    sql = 'select * from public_newsletters
    left join customers on email = `customers_email_address`
    where customers_email_address is null'
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |h| 
      EmailVisionCustomer.create( :email => h['email'], :client_type => 'public', :language_id => h['language_id'])
    end
  
  end
end