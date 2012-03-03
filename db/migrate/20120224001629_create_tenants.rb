class CreateTenants < ActiveRecord::Migration
  def change
    create_table :spree_tenants do |t|
      t.string :domain
      t.string :code

      t.timestamps
    end
  end
end
