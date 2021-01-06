require "rails_helper"

RSpec.describe "Merchant Dashboard" do
  let(:merchant1) do 
    create(:merchant)
  end

  describe "Displays" do
    it "the merchant name" do
      visit dashboard_merchant_path(merchant1)

      expect(page).to have_content(merchant1.name)
    end

    it "link to merchant's item index" do
      visit dashboard_merchant_path(merchant1)

      click_link "My Items"

      expect(current_path).to eq(merchant_items_path(merchant1))
    end

    it "link to merchant's invoices index" do
      visit dashboard_merchant_path(merchant1)

      click_link "My Invoices"

      expect(current_path).to eq(merchant_invoices_path(merchant1))
    end

    describe "the statistics, including:" do
      it "the top 5 customers" do
        FactoryBot.create_list(:customer, 10)
        Customer.all.each_with_index do |customer, index|
          (index + 1).times do
            invoice = create(:invoice, merchant: merchant1, customer: customer)
            create(:transaction, invoice: invoice, result: 0)
          end
        end

        visit dashboard_merchant_path(merchant1)

        within "#favorite_customers" do
          best_customers = Customer.last(5)
          not_best_customers = Customer.first(5)
          best_customers.each do |customer|
            expect(page).to have_content(customer.name)
          end
          not_best_customers.each do |customer|
            expect(page).to_not have_content(customer.name)
          end
        end
      end
    end
  end
end