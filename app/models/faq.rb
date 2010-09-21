class Faq < ActiveRecord::Base

    named_scope :ordered, :order => "ordered ASC"
end