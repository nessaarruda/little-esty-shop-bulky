class Merchant::BulkDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.bulk_discounts
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @discount = BulkDiscount.new
  end

  def create
    @discount = Merchant.find(params[:merchant_id]).bulk_discounts.create!(discount_params)
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  def destroy
    @discount = BulkDiscount.find(params[:id])
    @discount.destroy
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    @discount = BulkDiscount.find(params[:id])
    @discount.update(discount_params)

    redirect_to merchant_bulk_discount_path(params[:merchant_id], @discount)
  end

  private

  def discount_params
    params.require(:bulk_discount).permit(:name, :percentage, :quantity)
  end
end
