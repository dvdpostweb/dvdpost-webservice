class Category < ActiveRecord::Base
  set_primary_key :categories_id

  belongs_to :parent, :class_name => 'Category', :foreign_key => :parent_id
  has_many :descriptions, :class_name => 'CategoryDescription', :foreign_key => :categories_id
  has_and_belongs_to_many :products, :join_table => :products_to_categories, :foreign_key => :categories_id, :association_foreign_key => :products_id

  named_scope :by_kind, lambda {|kind| {:conditions => {:categories_type => DVDPost.product_kinds[kind]}}}
  named_scope :movies, :conditions => {:product_type => 'Movie'}
  named_scope :roots, :conditions => {:parent_id => 0}
  named_scope :visible_on_homepage, :conditions => {:show_home => 'YES'}
  named_scope :active, :conditions => {:active => 'YES'}
  named_scope :remove_theme, :conditions => 'categories_id != 105'
  
  named_scope :ordered, :order => 'display_group ASC, sort_order ASC'

  def name
    descriptions.by_language(I18n.locale).first ? descriptions.by_language(I18n.locale).first.name : "NONAME_#{to_param}"
  end

  def root?
    parent_id == 0
  end
end
