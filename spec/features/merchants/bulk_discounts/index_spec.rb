require 'rails_helper'

RSpec.describe "bulk discount" do 
  before :each do 
    @merchant = create(:merchant)
    @discount = create(:discount, merchant_id: @merchant.id)
    @discount2 = create(:discount, merchant_id: @merchant.id)
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
        expect(page).to have_content(@discount.discount / 100.0)
        click_on "Discount Link"
        expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount))
      end
    end

    it "displays a link to create a new discount" do 
      visit merchant_bulk_discounts_path(@merchant)

      before_save_count = @merchant.bulk_discounts.count
      click_on "Create New Discount"
      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))
      fill_in "quantity_threshold", with: 20
      fill_in "discount", with: 20
      click_on "Create"
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
      expect(@merchant.bulk_discounts.count).to eq(before_save_count + 1)

      within("#bulk-discount-#{@merchant.bulk_discounts.last.id}") do 
        expect(page).to have_content(20)
        expect(page).to have_content(0.2)
      end
    end

    it "displays a link to delete each discount" do 
      visit merchant_bulk_discounts_path(@merchant)

      expect(page).to have_css("#bulk-discount-#{@discount2.id}")
      within("#bulk-discount-#{@discount2.id}") do 
        expect(page).to have_button('Delete Discount')
        click_on "Delete Discount"
      end
      expect(page).to_not have_css("#bulk-discount-#{@discount2.id}")
    end
  end
end