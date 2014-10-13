task :cron2 => :environment do
  puts "cron2"
  StreamingProduct.zen_output_status
  puts "done."
end