task :cron => :environment do
  puts "cron"
  StreamingProduct.zen_coder_s
  puts "done."
end