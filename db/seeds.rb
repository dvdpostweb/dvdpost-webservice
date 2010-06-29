ProductList.delete_all
ListedProduct.delete_all
product=[[129,1232,91,115546,8715,439,2465,983,123483,104215],[129,1232,91,115546,8715,3901,124400,983,123486,104216],[129,1232,91,115546,8715,439,2465,983,123483,104215]]
['Films de Vampires','Vampierenfilms','Vampire movies'].each_with_index do |product_id, i|
  productList=ProductList.create(:name => product_id, :home_page => 1, :language => (i+1), :kind => 'TOP', :status => true)
  product[i].each_with_index do |product_id, j|
    ListedProduct.create(:product_id => product_id, :product_list_id => productList.to_param, :order => (j+1))
  end
end
bolywood=[
[111337,123914,123984,123985,123987,123988,123989,123991,123997,124014,124020,124023,124024,124025,124027,124032,124037,124038,124040,124043,124057,124060,124062,124063,124064,124065,124066,124067,124068,124075,124076,124077,124079,124080,124083,124084,124085,124088,124089,124090,124091,124092,124093,124094,124095,124105,124111,124119,124125,124130,124137,124160,124162,124171,124173,124174],
[111337,123914,123984,123985,123987,123988,123989,123991,123997,124014,124020,124023,124024,124025,124027,124032,124037,124038,124040,124043,124057,124060,124062,124063,124064,124065,124066,124067,124068,124075,124076,124077,124079,124080,124083,124084,124085,124088,124089,124090,124091,124092,124093,124094,124095,124105,124111,124119,124125,124130,124137,124160,124162,124171,124173,124174],
[111337,123914,123984,123985,123987,123988,123989,123991,123997,124014,124020,124023,124024,124025,124027,124032,124037,124038,124040,124043,124057,124060,124062,124063,124064,124065,124066,124067,124068,124075,124076,124077,124079,124080,124083,124084,124085,124088,124089,124090,124091,124092,124093,124094,124095,124105,124111,124119,124125,124130,124137,124160,124162,124171,124173,124174]
]
['Bollywood','Bollywood','Bollywood'].each_with_index do |product_id, i|
  productList=ProductList.create(:name => product_id, :home_page => 1, :language => (i+1), :kind => 'THEME', :status => true)
  bolywood[i].each_with_index do |product_id, j|
    ListedProduct.create(:product_id => product_id, :product_list_id => productList.to_param, :order => (j+1))
  end
end
Faq.delete_all

faq=[10,8,7,5,8,7,4,3,1].each_with_index do |q, i|
  Faq.create(:active => 1, :nb_questions => q, :name => "cat_#{i}")
end
Landing.delete([55,56,57,58,59])
keys= Hash.new
keys[55] = Hash.new(:id => 0   , :kind => 'OTHER',       :name => 'new_website')
keys[56] = Hash.new(:id => 0   , :kind => 'OTHER',       :name => 'parrainage')
keys[57] = Hash.new(:id => 15  , :kind => 'CATEGORY',    :name => 'nine')
keys[58] = Hash.new(:id => 58  , :kind => 'ACTOR',      :name => 'ben stiller')
keys[59] = Hash.new(:id => 109 , :kind => 'DIRECTOR',  :name => 'peter jackson')

keys.each do |key, value| 
  l=Landing.new
  l.id = key.to_i
  l.name = value[0][:name]
  l.expirated_date = Time.now+2529000
  l.reference_id = value[0][:id]
  l.kind = value[0][:kind]
  l.login = 1
  l.save!
end

  




