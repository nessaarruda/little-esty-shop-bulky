class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    Invoice.joins(:invoice_items)
           .where("invoice_items.status = 0 or invoice_items.status = 1")
           .order(:created_at)
           .distinct
  end

  def check_discount(data)
    require "pry"; binding.pry
  end
end
