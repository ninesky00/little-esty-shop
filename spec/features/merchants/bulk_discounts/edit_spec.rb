require 'rails_helper'

RSpec.describe "bulk discount edit page" do 
  before :each do 
    @merchant = create(:merchant)
    @discount = create(:discount, merchant_id: @merchant.id)
    visit edit_merchant_bulk_discount_path(@merchant, @discount)
  end
  
  it "displays a form and when updated, discount should update on the show page" do 
    expect(page.find_field('quantity_threshold').value).to eq("#{@discount.quantity_threshold}")
    expect(page.find_field('discount').value).to eq("#{@discount.discount}")

    fill_in "quantity_threshold", with: 30
    fill_in "discount", with: 30
    click_on "Update"

    expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount))
    
    within("#discount-attributes") do 
      expect(page).to have_content(30)
      expect(page).to have_content(30)
    end
  end
  it "stays on the page if fields are not filled" do
    fill_in "quantity_threshold", with: ""
    fill_in "discount", with: ""
    click_on "Update"

    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @discount))
    
  end
end
