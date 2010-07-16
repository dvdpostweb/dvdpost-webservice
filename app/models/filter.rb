class Filter < ActiveRecord::Base
  def audience?
    audience_min? || audience_max?
  end

  def rating?
    rating_min? || rating_max?
  end

  def year?
    year_min? || year_max?
  end
end
