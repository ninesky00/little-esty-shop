require 'rails_helper'

RSpec.describe "Admin Dashboard" do 
  describe "visit admin dashboard" do 
    it "can see a header indicating admin dashboard" do 
      visit "/admin"

      expect(page).to have_content("admin dashboard")
    end
  end

  describe "admin dashboard links" do 
    it "can see links to admin merchants index" do 
      visit "/admin"
      click_on 'merchants'
      expect(current_path).to eq(admin_merchants_path)
    end
  end

  describe "admin dashboard links" do 
    it "can see links to admin invoices index" do 
      visit "/admin"
      click_on 'invoices'
      expect(current_path).to eq(admin_invoices_path)
    end
  end

  describe "dashboard top customers" do 
    it "can see the names of top 5 customers" do 
      customers = []
      10.times { customers << create(:customer) }
      customers.each do |customer|
        create(:invoice, customer_id:customer.id)
      end
      first_customer = customers[0].invoices[0].id
      second_customer = customers[1].invoices[0].id
      third_customer = customers[2].invoices[0].id
      fourth_customer = customers[3].invoices[0].id
      fifth_customer = customers[4].invoices[0].id
      sixth_customer = customers[5].invoices[0].id
      seventh_customer = customers[6].invoices[0].id
      
      10.times { create(:transaction, invoice_id:first_customer, result: "success")}
      9.times { create(:transaction, invoice_id:second_customer, result: "success")}
      8.times { create(:transaction, invoice_id:third_customer, result: "success")}
      7.times { create(:transaction, invoice_id:fourth_customer, result: "success")}
      6.times { create(:transaction, invoice_id:fifth_customer, result: "success")}
      5.times { create(:transaction, invoice_id:sixth_customer, result: "success")}
      13.times { create(:transaction, invoice_id:seventh_customer, result: "failed")}
      
      visit "/admin"
      
      customer1 = page.find("#customer-#{customers[0].id}")
      customer2 = page.find("#customer-#{customers[1].id}")
      customer3 = page.find("#customer-#{customers[2].id}")
      customer4 = page.find("#customer-#{customers[3].id}")
      customer5 = page.find("#customer-#{customers[4].id}")

      expect(customer1).to appear_before(customer2)
      expect(customer2).to appear_before(customer3)
      expect(customer3).to appear_before(customer4)
      expect(customer4).to appear_before(customer5)
      expect(page).to_not have_css("#customer-#{customers[5].id}")
      expect(page).to_not have_css("#customer-#{customers[6].id}")
    end
  end

end
