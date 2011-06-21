class HighlightProduct < ActiveRecord::Base

  named_scope :day, lambda {|day| {:conditions => {:day => day}}}
  named_scope :by_kind, lambda {|kind| {:conditions => {:kind => kind}}}
  named_scope :by_language, lambda {|language| {:conditions => {:language_id => language}}}

end