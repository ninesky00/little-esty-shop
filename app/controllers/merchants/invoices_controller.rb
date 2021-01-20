class Merchants::InvoicesController < ApplicationController
  def index
    @invoices = Merchant.find(params[:merchant_id]).invoices
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @invoice = Invoice.find(params[:id])
    @invoice_items = @invoice.invoice_items.regular_price_items
    @discounted_items = @invoice.invoice_items.discounted_items
  end
end
