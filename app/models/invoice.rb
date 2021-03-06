class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :merchant_id,
                        :customer_id

  belongs_to :merchant
  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :bulk_discounts, through: :merchants

  enum status: [:cancelled, :in_progress, :complete]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discounted_total_revenue
    invoiceitems = InvoiceItem.joins(:invoice).where(invoice_id: self.id)
    total = 0
    invoiceitems.each do |invoice|
      total += check_discount(invoice.quantity, invoice.item_id)
    end
    total
  end

  def check_discount(quantity, item_id)
    percentage = BulkDiscount
                .joins(:merchant)
                .where(merchant_id: self.merchant.id)
                .where("quantity <= ?", quantity)
                .order(percentage: :desc)
                .pluck(:percentage).first
    total(item_id, percentage, quantity)
  end

  def total(item_id, percentage, quantity)
    total = 0
    percentage = 0 if !percentage
    Item.joins(:invoice_items).each do |item|
      if item.id == item_id
        unit_price = item.unit_price * (1 - percentage)
        total = unit_price * quantity
      end
    end
    total
  end
end 
