class ChangeColumnNameInvoiceItems < ActiveRecord::Migration[5.2]
  def change
    rename_column :invoice_items, :discount, :discount_id
  end
end
