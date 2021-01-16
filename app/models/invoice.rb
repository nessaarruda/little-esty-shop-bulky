class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :merchant_id,
                        :customer_id

  belongs_to :merchant
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :bulk_discounts, through: :merchants

  enum status: [:cancelled, :in_progress, :complete]

  def discounted_total_revenue
    invoiceitems = InvoiceItem.joins(:invoice).where(invoice_id: self.id)
    total = 0
    invoiceitems.each do |invoice|
      total += check_discount(invoice.quantity, invoice.item_id)
    end
    total
  end

  def check_discount(quantity, item_id)
    quantity_array = BulkDiscount
                    .joins(:merchant)
                    .where(merchant_id: self.merchant.id)
    percentage = 0.0
    quantity_array.each do |discount|

      if discount.quantity <= quantity
        percentage = discount.percentage if discount.percentage > percentage
      end
    end
    total = 0
    Item.joins(:invoice_items).each do |item|
      if item.id == item_id
        unit_price = item.unit_price * (1 - percentage)
        total = unit_price * quantity
      end
    end
    total
  end
end
