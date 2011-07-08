class HighlightReview < ActiveRecord::Base

  named_scope :by_language, lambda {|language| {:conditions => {:language_id => language}}}

  def self.run_reviews
    3.times do |i|
      language = i+1
      self.run_reviews_by_language(language)
    end 
  end

  private
  def self.run_reviews_by_language(language_id)
    HighlightReview.by_language(language_id).destroy_all
    rank = 0
    Review.approved.by_language(language_id).ordered.limit(12).all(:joins => "left join products on products.products_id = reviews.products_id and products_status !=1 and products_type='dvd_norm'").collect do |review|
      rank += 1
      HighlightReview.create(:review_id => review.to_param, :language_id => language_id, :rank => rank)
    end
  end
end