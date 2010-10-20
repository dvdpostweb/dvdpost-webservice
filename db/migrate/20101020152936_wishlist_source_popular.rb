class WishlistSourcePopular < ActiveRecord::Migration
  def self.up
    change_column :wishlist, :source_added, 'enum("CANCELORDER","RECOMMANDATION","RECOMMANDATION_PRODUCT","RECOMMANDATION_MAIL","POPULAR","ELSEWHERE")'
    change_column :wishlist_assigned, :source_added, 'enum("RECOMMANDATION","RECOMMANDATION_PRODUCT","RECOMMANDATION_MAIL","POPULAR","ELSEWHERE")'
  end

  def self.down
    change_column :wishlist, :source_added, 'enum("CANCELORDER","RECOMMANDATION","RECOMMANDATION_PRODUCT","RECOMMANDATION_MAIL","ELSEWHERE")'
    change_column :wishlist_assigned, :source_added, 'enum("RECOMMANDATION","RECOMMANDATION_PRODUCT","RECOMMANDATION_MAIL","ELSEWHERE")'
  end
end
