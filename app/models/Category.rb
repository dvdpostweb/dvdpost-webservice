class Category < ActiveRecord::Base
  set_primary_key :categories_id

  belongs_to :parent, :class_name => 'Category', :foreign_key => :parent_id
  has_and_belongs_to_many :products, :join_table => :products_to_categories, :foreign_key => :categories_id, :association_foreign_key => :products_id
  has_many :children, :class_name => 'Category', :foreign_key => :parent_id

  named_scope :by_kind, lambda {|kind| {:conditions => {:categories_type => DVDPost.product_kinds[kind]}}}
  named_scope :movies, :conditions => {:product_type => 'Movie'}
  named_scope :roots, :conditions => {:parent_id => 0}
  named_scope :visible_on_homepage, :conditions => {:show_home => 'YES'}
  named_scope :active, :conditions => {:active => 'YES'}
  named_scope :remove_themes, :conditions => 'categories_id != 105'
  named_scope :hetero, :conditions => 'categories_id != 76'
  named_scope :vod, :conditions => {:vod => true}
  
  def self.vod_available
    sql = "select  distinct c.categories_id  from products p
        join streaming_products sp on sp.imdb_id = p.imdb_id 
        join products_to_categories c on c.products_id = p.products_id
        where p.imdb_id != 0 and sp.available = 1  and status = 'online_test_ok' and ((available_from < now() and expire_at > now()) or (`available_backcatalogue_from`<now() and `expire_backcatalogue_at`>now()))"
    
    results = ActiveRecord::Base.connection.execute(sql)
    puts results.inspect
    Category.update_all(:vod => 0)
    results.each_hash do |h|
      id = h['categories_id']
      cat = Category.find_by_categories_id(id)
      if cat
        cat.update_attributes(:vod => 1)
      end
    end
  end
end
