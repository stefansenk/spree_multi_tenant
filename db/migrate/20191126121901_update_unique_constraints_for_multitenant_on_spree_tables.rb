class UpdateUniqueConstraintsForMultitenantOnSpreeTables < ActiveRecord::Migration[4.2]
  def change
    tables = {
      country: [{name: [:case_insensitive]}, {iso_name: [:case_insensitive]}, :iso, :iso3],
      customer_return: [:number],
      order: [:number],
      payment: [:number],
      preferences: [:key],
      product: [:slug],
      promotion: [{code: [:case_insensitive]}],
      refund_reason: [{name: [:case_insensitive]}],
      reimbursement: [:number],
      reimbursement_type: [{name: [:case_insensitive]}],
      return_authorization: [:number],
      return_authorization_reason: [{name: [:case_insensitive]}],
      role: [{name: [:case_insensitive]}],
      shipment: [:number],
      stock_transfer: [:number],
      store: [{code: [:case_insensitive]}],
      tag: [:name],
      user: [:email],
    }

    tables.each do |table, column_infos|
      table_class = "Spree::#{table.to_s.classify}".safe_constantize
      if table_class
        table_name = table_class.table_name

        column_infos.each do |column_info|
          column = column_info.is_a?(Symbol) ? column_info : column_info.keys.first
          column_options = column_info.is_a?(Symbol) ? [] : column_info.values.first
          is_case_insensitive = column_options.include?(:case_insensitive) &&
            supports_expression_index?
          column_expression = is_case_insensitive ? "lower(#{column})" : column
          column_expression_for_index = is_case_insensitive ? "lower_#{column}" : column
          # When attempting to find the old index, might need to find by index_custom_name:
          index_custom_name =
            if table == :user # Special case
              'email_idx_unique'
            else # General case
              "index_#{table_name}_on_#{column_expression_for_index}"
            end

          if index_exists?(table_name, column, unique: true)
            remove_index table_name, column
            add_index table_name, column # change to NOT unique
          elsif index_name_exists?(table_name, index_custom_name)
            remove_index table_name, name: index_custom_name
            add_index table_name, column_expression # change to NOT unique
          end

          add_index table_name,
            "#{column_expression}, tenant_id",
            unique: true,
            name: index_custom_name + "_tenant" # Avoid "Index name is too long"
        end
      end
    end
  end
end
