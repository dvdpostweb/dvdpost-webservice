class Product < ActiveRecord::Base
  set_primary_key "products_id"

  alias_attribute :kind,  :products_type
  alias_attribute :title, :products_title

  has_many :descriptions, :foreign_key => :products_id

  def description
    descriptions.by_language(I18n.locale.to_s)
  end
end
