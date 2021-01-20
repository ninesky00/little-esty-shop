class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  validates :quantity_threshold, numericality: { only_integer: true, greater_than: 4 }
  validates :discount, numericality: { only_integer: true, less_than: 100 }
end