class AddMessageReadFlag < ActiveRecord::Migration
  class Message < ActiveRecord::Base; end
  
  def self.up
    add_column :custserv, :is_read, :boolean, :default => 0
    connection.execute "update custserv set is_read = 1;"
  end

  def self.down
    remove_column :custserv, :is_read
  end
end
