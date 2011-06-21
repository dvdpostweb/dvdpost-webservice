class HighlightReview < ActiveRecord::Base

  named_scope :by_language, lambda {|language| {:conditions => {:language_id => language}}}

  def self.run_reviews(language_id)
    HighlightReview.by_language(language_id).destroy_all
    rank = 0
    Review.approved.by_language(language_id).ordered.limit(10).collect do |review|
      rank += 1
      HighlightReview.create(:review_id => review.to_param, :language_id => language_id, :rank => rank)
    end
  end
end