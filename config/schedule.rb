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
 set :output, './log/cron.log'
 every 1.day, :at => '11:20 am' do
   runner "HighlightCustomer.add_point_by_day"
 end
 every 1.day, :at => '11:30 am' do
   runner "HighlightCustomer.add_point"
 end
 every 1.day, :at => '11:55 am' do
   runner "HighlightReview.run_reviews"
 end
 every 1.day, :at => '12:00 am' do
   runner "HighlightProduct.run_best_rating"
 end
 every 1.day, :at => '12:05 am' do
   runner "HighlightProduct.run_controverse_rating"
 end
 every 1.day, :at => '12:10 am' do
   runner "HighlightCustomer.run_best_customer_all"
 end
 every 1.day, :at => '12:15 am' do
   runner "HighlightCustomer.run_best_customer_month"
 end

# Learn more: http://github.com/javan/whenever
