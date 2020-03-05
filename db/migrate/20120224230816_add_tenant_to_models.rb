class AddTenantToModels < ActiveRecord::Migration[4.2]
  def change
    tables = SpreeMultiTenant.tenanted_models.map(&:table_name).uniq
    tables.each do |table|
      add_column table, :tenant_id, :integer, default: 0
      change_column table, :tenant_id, :integer, null: false
      change_column_default table, :tenant_id, nil
      add_index table, :tenant_id
    end
    SpreeMultiTenant.tenanted_models.each(&:reset_column_information)
  end
end

