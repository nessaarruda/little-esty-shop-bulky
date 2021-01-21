class Merchant::InvoicesController < ApplicationController
  before_action :find_invoice, only: [:show, :update]
  before_action :find_merchant, only: [:index, :show, :update]

  def index
    @invoices = @merchant.invoices
  end

  def show
    @customer = @invoice.customer
    @invoice_item = InvoiceItem.where(invoice_id: params[:id]).first
  end

  def update
    @invoice.update(invoice_params)
    redirect_to merchant_invoice_path(@merchant, @invoice)
  end

  private
  def invoice_params
    params.require(:invoice).permit(:status)
  end

  def find_invoice
    @invoice = Invoice.find(params[:id])
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
