class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_one :merchant, through: :item

  enum status: ["pending", "packaged", "shipped"]

  delegate :name, to: :item, prefix: true

  def self.invoice_amount
    sum('quantity * unit_price')
  end

  def self.find_discount(id)
    joins(merchant: :bulk_discounts)
    .select("invoice_items.*, bulk_discounts.discount, bulk_discounts.id as discount_id")
    .where("invoice_items.quantity >= bulk_discounts.quantity_threshold and invoice_items.id = #{id}")
    .order(discount: :desc)
    .limit(1)
    .take
  end

  def apply_discount
    applicable = self.class.find_discount(self.id)
    if applicable
      self.update_columns(unit_price: self.unit_price * ((100 - applicable.discount)/100.0),
                          discount_id: applicable.discount_id)
    end
  end

  def self.invoice_amount_with_discount
    self.all.each do |invoice_item|
      if invoice_item.discount_id
        next
      else
        invoice_item.apply_discount
      end
    end
    self.invoice_amount
  end

  def self.discounted_items
    where('discount_id > 0')
  end

  def self.regular_price_items
    where('discount_id is null')
  end
  # def self.invoice_amount_with_discount
  #   invoice_amount - discounted_price
  # end

  # def self.discounted_price
  #   joins(merchant: :bulk_discounts)
  #   .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
  #   .order('bulk_discounts.discount' => :desc)
  #   .sum("invoice_items.quantity * invoice_items.unit_price * bulk_discounts.discount / 100")
  # end
end
