class Movie < ActiveRecord::Base
  validates_presence_of :title, :filename
  # filename contains the filename without the .flv extension
end
