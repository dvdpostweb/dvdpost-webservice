class Public < ActiveRecord::Base
  set_table_name :public

  set_primary_key :public_id

  alias_attribute :description, :public_name

  belongs_to :product

  def name
    DVDPost.local_product_publics[to_param.to_i]
  end

  def image
    "public_#{name}.gif"
  end

  def self.legacy_age_ids(min, max)
    ages = []
    if max.to_i == 0
      ages << DVDPost.product_publics[:all]
    else
      ages << DVDPost.product_publics.keys.collect do |age|
        DVDPost.product_publics[age] if age != :all && age.to_i.between?(min.to_i, max.to_i)
      end
    end  
    ages.flatten.uniq.compact
  end
end
