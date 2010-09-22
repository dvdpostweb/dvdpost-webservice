class ChangeNameBetaTest < ActiveRecord::Migration
  def self.up
    rename_table :beta_test, :beta_tests
  end

  def self.down
    rename_table :beta_tests, :beta_test
  end
end
