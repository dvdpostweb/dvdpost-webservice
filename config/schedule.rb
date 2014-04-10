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
 every 1.day, :at => '12:35 pm' do
   runner "HighlightProduct.run_best_rating"
 end
 every 1.day, :at => '12:40 pm' do
   runner "HighlightProduct.run_best_rating_vod"
 end
 every 1.day, :at => '12:10 pm' do
   runner "HighlightProduct.run_controverse_rating"
 end
 every 1.day, :at => '12:15 pm' do
   runner "HighlightCustomer.run_best_customer_all"
 end
 every 1.day, :at => '12:20 pm' do
   runner "HighlightCustomer.run_best_customer_month"
 end
 every 1.day, :at => '12:30 pm' do
   runner "Category.vod_available"
 end
 every 1.day, :at => '12:30 pm' do
   runner "Category.vod_available"
 end
 every 1.day, :at => '9:30 pm' do
   runner "Payment.verify_paypal"
 end
 every '30	9,12,15,17	*	*	1,2,3,4,5' do
   runner "Customer.abo_missing"
 end
 every '30	12,21	*	*	0,6' do
   runner "Customer.abo_missing"
 end
 
 every 1.day, :at => '1:30 pm' do
   runner "Session.delete_old_sessions"
 end
 


# Learn more: http://github.com/javan/whenever
