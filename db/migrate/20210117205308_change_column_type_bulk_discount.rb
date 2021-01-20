class ChangeColumnTypeBulkDiscount < ActiveRecord::Migration[5.2]
  def change
    change_column(:bulk_discounts, :discount, :integer)
  end
end
