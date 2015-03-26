class Payment < ActiveRecord::Base
  set_table_name :payment

  def self.verify_paypal
    sql = 'select count(*) nb from payment p
    left join paypal_payments_history pp on p.id = payment_id 
    where payment_method=4 and pp.id is null and date(date_added) = date(now())'
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |h|
      if h['nb'].to_i > 0
        Emailer.deliver_send('it@dvdpost.be, im@dvdpost.be', "missing paypal transation #{Date.today}", "#{h['nb']} transation are missing")
      end
    end
  end
end