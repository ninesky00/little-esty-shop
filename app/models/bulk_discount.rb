class BulkDiscount < ApplicationRecord
  validates :discount, numericality: {less_than: 1}
  belongs_to  :merchant
end