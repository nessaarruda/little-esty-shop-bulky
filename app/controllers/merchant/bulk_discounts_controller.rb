class Merchant::BulkDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = BulkDiscount.all
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def new
  end

  def create
    @discount = BulkDiscount.new(discount_params)
    @discount.merchant_id = params[:merchant_id]
    if @discount.save
      redirect_to merchant_bulk_discounts_path(params[:merchant_id])
    else
      flash.notice = "All fields must be completed, get your act together."
      render :new
    end
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
    params.require(:bulk_discount).permit(:percentage, :quantity)
  end
end
