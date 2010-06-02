class ProductDvd < ActiveRecord::Base
  set_table_name :products_dvd

  belongs_to :status, :class_name => 'ProductDvdStatus', :foreign_key => :products_dvd_status

  def to_param
    products_dvdid
  end

  def update_status!(status)
    connection.execute("UPDATE products_dvd SET products_dvd_status = #{status.to_param}, last_admindate = '#{Time.now.to_s(:db)}' WHERE products_id = #{products_id} AND products_dvdid = #{products_dvdid}")
    true
  end
end
