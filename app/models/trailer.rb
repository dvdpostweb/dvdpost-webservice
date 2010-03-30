class Trailer < ActiveRecord::Base
  set_table_name :products_trailers

  set_primary_key :trailers_id

  alias_attribute :broadcast_service, :broadcast
  alias_attribute :remote_id, :trailer

  belongs_to :product, :foreign_key => :products_id

  named_scope :by_language, lambda {|language| {:conditions => {:language_id => DVDPost.product_languages[language]}}}

  def url
    DVDPost.trailer_broadcasts_urls[broadcast_service] + remote_id
  end
end
