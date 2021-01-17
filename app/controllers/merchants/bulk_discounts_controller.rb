class Merchants::BulkDiscountsController < ApplicationController
  before_action :set_merchant
  
  def index
    @discounts = BulkDiscount.all
  end

  def new
  end

  def create
    discount = BulkDiscount.create!(bulk_discount_params.merge(merchant: @merchant))
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
    BulkDiscount.destroy(params[:id])
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private
  def bulk_discount_params
    params.permit(:quantity_threshold, :discount)
  end

  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
