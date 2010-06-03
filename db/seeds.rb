# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

ListedProduct.delete_all("product_list_id = 1 ")
[129,1232,91,115546,8715,3901,124400,983,123486,104216].each_with_index do |product_id, i|
  ListedProduct.create(:product_id => product_id, :product_list_id => 1, :order => (i+1))
end
