class Product < ActiveRecord::Base
  KINDS = {'dvd' => 'DVD_NORM', 'adult' => 'DVD_ADULT', 'subscription' => 'ABO'}

  set_primary_key "products_id"

  alias_attribute :kind,  :products_type
  alias_attribute :title, :products_title

  has_many :descriptions, :foreign_key => :products_id

  named_scope :limit, lambda {|limit| {:limit => limit}}
  named_scope :by_kind, lambda {|kind| {:conditions => {:products_type => KINDS[kind]}}}

  def description
    descriptions.by_language(I18n.locale.to_s).first
  end
end
