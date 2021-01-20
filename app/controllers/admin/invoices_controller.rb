class Admin::InvoicesController < ApplicationController
  def index
    @invoices = Invoice.order(:id)
  end

  def show
    @invoice = Invoice.find(params[:id])
    @discounted_items = @invoice.invoice_items.discounted_items
    @regular_items = @invoice.invoice_items.regular_price_items
  end

  def update
    invoice = Invoice.find(params[:id])
    invoice.update(invoice_params)
    redirect_to admin_invoice_path(invoice)
  end

  private
  def invoice_params
    params.permit(:status)
  end
end
