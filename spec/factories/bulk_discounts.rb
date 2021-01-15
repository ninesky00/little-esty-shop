FactoryBot.define do
  factory :discount, class: BulkDiscount do
    association :merchant
    quantity_threshold { Faker::Number.within(range: 5..50) }
    discount { Faker::Number.decimal(l_digits: 0) }
  end
end