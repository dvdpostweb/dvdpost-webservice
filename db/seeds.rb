# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

ProductList.delete_all
ListedProduct.delete_all
product=[[129,1232,91,115546,8715,439,2465,983,123483,104215],[129,1232,91,115546,8715,3901,124400,983,123486,104216],[129,1232,91,115546,8715,439,2465,983,123483,104215]]
['Films de Vampires','Films de Vampires','Films de Vampires'].each_with_index do |product_id, i|
  productList=ProductList.create(:name => product_id, :home_page => 1, :language => (i+1), :kind => 'TOP', :status => true)
  product[i].each_with_index do |product_id, j|
    ListedProduct.create(:product_id => product_id, :product_list_id => productList.to_param, :order => (j+1))
  end
end


