class UpdateConstraintOnSpreePreferencesKey < ActiveRecord::Migration
  def up
    remove_index :spree_preferences, :column => :key
    add_index :spree_preferences, :key
  end
  def down
    remove_index :spree_preferences, :column => :key
    add_index :spree_preferences, :key, :unique => true
  end
end

