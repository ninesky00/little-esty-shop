require 'rails_helper'

RSpec.describe "merchant bulk discount" do 
  before :each do 
    @merchant = create(:merchant)
    @discount = create(:discount, merchant_id: @merchant.id)
  end

  describe "buld discount new page" do
    it "can create a new discount" do  
      visit new_merchant_bulk_discount_path(@merchant)

      fill_in "quantity_threshold", with: 20
      fill_in "discount", with: 20
      click_on "Create"
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))

      within("#bulk-discount-#{@merchant.bulk_discounts.last.id}") do 
        expect(page).to have_content(20)
        expect(page).to have_content(20)
      end
    end
  end
end