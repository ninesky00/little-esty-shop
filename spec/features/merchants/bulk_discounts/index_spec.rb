require 'rails_helper'

RSpec.describe "bulk discount" do 
  before :each do 
    @merchant = create(:merchant)
    @discount = create(:discount)
  end

  describe "merchant bulk discount index" do 
    it "has a link from merchant dashboard to the bulk discount index" do 
      visit dashboard_merchant_path(@merchant)

      click_link "My Discounts"
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
    end

    it "display all the merchant discounts including discount attributes and link" do 
      visit merchant_bulk_discounts_path(@merchant)

      within("#bulk-discount-#{@discount.id}") do 
        expect(page).to have_content(@discount.quantity_threshold)
        expect(page).to have_content((@discount.discount*100).to_i)
        click_on "#{(@discount.discount*100).to_i}"
        expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount))
      end
    end
  end
end