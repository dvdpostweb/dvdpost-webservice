# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
 every 1.day, :at => '10:55 am' do
   runner "HighlightReview.run_reviews"
   runner "HighlightProduct.run_best_rating"
   runner "HighlightProduct.run_controverse_rating"
 end

# Learn more: http://github.com/javan/whenever
