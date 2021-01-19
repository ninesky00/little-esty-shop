require 'rails_helper'

RSpec.describe "bulk discount show page" do
  before :each do 
    @merchant = create(:merchant)
    @discount = create(:discount, merchant_id: @merchant.id)
    visit merchant_bulk_discount_path(@merchant, @discount)
  end
  it "displays the discount quantity and price discount" do 
    within("#discount-attributes") do 
      expect(page).to have_content(@discount.quantity_threshold)
      expect(page).to have_content(@discount.discount)
    end
  end

  it "displays a link to edit the bulk discount" do 
    within("#discount-attributes") do 
      expect(page).to have_link("Edit Discount")
      click_on "Edit Discount"
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @discount))
    end
  end
end 