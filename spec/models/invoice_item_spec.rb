require "rails_helper"

describe InvoiceItem, type: :model do
  before :each do 
    @merchant1 = create(:merchant)
    @discount = create(:discount, merchant: @merchant1, quantity_threshold: 10, discount: 10)
    @discount2 = create(:discount, merchant: @merchant1, quantity_threshold: 20, discount: 20)
    @discount3 = create(:discount, merchant: @merchant1, quantity_threshold: 30, discount: 30)
    @items = create_list(:item, 5, merchant: @merchant1, unit_price: 10)
    @discounted_items = create_list(:item, 5, merchant: @merchant1, unit_price: 10)
    @discounted_items2 = create_list(:item, 5, merchant: @merchant1, unit_price: 10)
    @discounted_items3 = create_list(:item, 5, merchant: @merchant1, unit_price: 10)
    @customer = create(:customer, first_name: "Linda", last_name: "Mayhew")
    @invoice = create(:invoice, merchant: @merchant1, customer: @customer)
    @invoice2 = create(:invoice, merchant: @merchant1, customer: @customer)
    @invoice3 = create(:invoice, merchant: @merchant1, customer: @customer)
    @invoice4 = create(:invoice, merchant: @merchant1, customer: @customer)
    @items.each do |item|
      create(:invoice_item, item: item, invoice: @invoice, quantity: 5, unit_price: 10)
    end
    @discounted_items.each do |discounted_item|
      create(:invoice_item, item: discounted_item, invoice: @invoice2, quantity: 10, unit_price: 10)
    end
    @discounted_items2.each do |discounted_item|
      create(:invoice_item, item: discounted_item, invoice: @invoice3, quantity: 20, unit_price: 10)
    end
    @discounted_items3.each do |discounted_item|
      create(:invoice_item, item: discounted_item, invoice: @invoice4, quantity: 30, unit_price: 10)
    end
  end

  describe "validations" do
    it {should define_enum_for(:status).with_values ["pending", "packaged", "shipped"] }
  end

  describe "relations" do
    it {should belong_to :invoice}
    it {should belong_to :item}
  end

  describe "class methods" do 
    it "invoice_amount" do 
      invoice = FactoryBot.create(:invoice)
      ii1 = FactoryBot.create(:invoice_item, invoice_id:invoice.id, quantity: 3, unit_price: 5) #15
      ii2 = FactoryBot.create(:invoice_item, invoice_id:invoice.id, quantity: 4, unit_price: 5) #20 
      ii3 = FactoryBot.create(:invoice_item, invoice_id:invoice.id, quantity: 5, unit_price: 5) #25

      expect(invoice.invoice_items.invoice_amount).to eq(15+20+25)
    end

    it "find_discount" do 
      expect(InvoiceItem.find_discount(@invoice.invoice_items.first.id)).to eq(nil)
      expect(InvoiceItem.find_discount(@invoice2.invoice_items.first.id).discount).to eq(10)
      expect(InvoiceItem.find_discount(@invoice3.invoice_items.first.id).discount).to eq(20)
      expect(InvoiceItem.find_discount(@invoice4.invoice_items.first.id).discount).to eq(30)
    end

    it "invoice_amount_with_discount" do 
      expect(@invoice2.invoice_items.invoice_amount).to eq(500)
      expect(@invoice3.invoice_items.invoice_amount).to eq(1000)
      expect(@invoice4.invoice_items.invoice_amount).to eq(1500)
      expect(@invoice2.invoice_items.invoice_amount_with_discount).to eq(450)
      expect(@invoice3.invoice_items.invoice_amount_with_discount).to eq(800)
      expect(@invoice4.invoice_items.invoice_amount_with_discount).to eq(1050)
    end

    it "discounted_items" do 
      @invoice2.invoice_items[0].apply_discount
      @invoice3.invoice_items[0].apply_discount
      @invoice4.invoice_items[0].apply_discount
      expected = @invoice2.invoice_items[0], @invoice3.invoice_items[0], @invoice4.invoice_items[0]
      expect(InvoiceItem.discounted_items).to eq(expected)
    end
  end

  describe "instance methods" do 
    it "apply_discount" do 
      expect(@invoice2.invoice_items[0].unit_price).to eq(10)
      expect(@invoice3.invoice_items[0].unit_price).to eq(10)
      expect(@invoice4.invoice_items[0].unit_price).to eq(10)
      @invoice2.invoice_items[0].apply_discount
      @invoice3.invoice_items[0].apply_discount
      @invoice4.invoice_items[0].apply_discount
      expect(@invoice2.invoice_items[0].unit_price).to eq(9)
      expect(@invoice3.invoice_items[0].unit_price).to eq(8)
      expect(@invoice4.invoice_items[0].unit_price).to eq(7)
      expect(@invoice2.invoice_items[0].discount_id).to eq(@discount.id)
      expect(@invoice3.invoice_items[0].discount_id).to eq(@discount2.id)
      expect(@invoice4.invoice_items[0].discount_id).to eq(@discount3.id)
    end

    it "discounted" do 
      @invoice2.invoice_items[0].apply_discount
      @invoice3.invoice_items[0].apply_discount
      @invoice4.invoice_items[0].apply_discount
      expect(@invoice.invoice_items[0].discounted?).to eq(false)
      expect(@invoice2.invoice_items[0].discounted?).to eq(true)
      expect(@invoice3.invoice_items[0].discounted?).to eq(true)
      expect(@invoice4.invoice_items[0].discounted?).to eq(true)
    end
  end
  
  describe "delegates" do
    it "fine" do
      create(:invoice_item)
      expect(InvoiceItem.first.item.name).to eq(InvoiceItem.first.item_name)
    end
  end
end

# it "discounted price" do 
#   @merchant1 = create(:merchant)
#   @discount = create(:discount, merchant: @merchant1, quantity_threshold: 10, discount: 10)
#   @discount2 = create(:discount, merchant: @merchant1, quantity_threshold: 20, discount: 20)
#   @discount3 = create(:discount, merchant: @merchant1, quantity_threshold: 30, discount: 30)
#   @items = create_list(:item, 5, merchant: @merchant1, unit_price: 10)
#   @discounted_items = create_list(:item, 5, merchant: @merchant1, unit_price: 10)
#   @discounted_items2 = create_list(:item, 5, merchant: @merchant1, unit_price: 10)
#   @discounted_items3 = create_list(:item, 5, merchant: @merchant1, unit_price: 10)
#   @customer = create(:customer, first_name: "Linda", last_name: "Mayhew")
#   @invoice = create(:invoice, merchant: @merchant1, customer: customer)
#   @invoice2 = create(:invoice, merchant: @merchant1, customer: customer)
#   @invoice3 = create(:invoice, merchant: @merchant1, customer: customer)

#   items.each do |item|
#     create(:invoice_item, item: item, invoice: invoice, quantity: 5, unit_price: 10)
#   end

#   discounted_items.each do |discounted_item|
#     create(:invoice_item, item: discounted_item, invoice: invoice, quantity: 10, unit_price: 10)
#   end

#   discounted_items2.each do |discounted_item|
#     create(:invoice_item, item: discounted_item, invoice: invoice2, quantity: 20, unit_price: 10)
#   end

#   discounted_items3.each do |discounted_item|
#     create(:invoice_item, item: discounted_item, invoice: invoice3, quantity: 30, unit_price: 10)
#   end

#   expect(invoice.invoice_items.discounted_price).to eq(50)
#   expect(invoice2.invoice_items.discounted_price).to eq(200)
#   expect(invoice3.invoice_items.discounted_price).to eq(450)
# end