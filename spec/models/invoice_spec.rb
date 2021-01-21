require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :merchant_id }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :merchant }
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many :transactions}
  end
  describe "instance methods" do
    it "total_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(merchant_id: @merchant1.id, customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.total_revenue).to eq(100)
    end
    it 'can check for discounts for invoices' do
      m1 = Merchant.create!(name: 'Merchant 1')
      m2 = Merchant.create!(name: 'Merchant 2')

      c1 = Customer.create!(first_name: 'Yo', last_name: 'Yoz')
      c2 = Customer.create!(first_name: 'Hey', last_name: 'Heyz')

      i1 = Invoice.create!(merchant_id: m1.id, customer_id: c1.id, status: 2, created_at: "2012-03-12 14:54:09")
      i2 = Invoice.create!(merchant_id: m1.id, customer_id: c1.id, status: 2, created_at: "2012-09-06 14:54:09")
      i3 = Invoice.create!(merchant_id: m1.id, customer_id: c2.id, status: 2, created_at: "2012-03-28 14:54:09")

      i4 = Invoice.create!(merchant_id: m2.id, customer_id: c1.id, status: 2, created_at: "2012-03-12 14:54:09")
      i5 = Invoice.create!(merchant_id: m2.id, customer_id: c1.id, status: 2, created_at: "2012-09-06 14:54:09")
      i6 = Invoice.create!(merchant_id: m2.id, customer_id: c2.id, status: 2, created_at: "2012-03-28 14:54:09")

      item_1 = Item.create!(name: 'pondering', description: 'hmmmm', unit_price: 10, merchant_id: m1.id)
      item_2 = Item.create!(name: 'thinking', description: 'hurts', unit_price: 8, merchant_id: m1.id)
      item_3 = Item.create!(name: 'best', description: 'aint this fun', unit_price: 5, merchant_id: m1.id)
      item_4 = Item.create!(name: 'pondering', description: 'hmmmm', unit_price: 15, merchant_id: m2.id)
      item_5 = Item.create!(name: 'thinking', description: 'hurts', unit_price: 10, merchant_id: m2.id)
      item_6 = Item.create!(name: 'best', description: 'aint this fun', unit_price: 5, merchant_id: m2.id)

      discount1 = m1.bulk_discounts.create!(name: 'A', percentage: 0.10, quantity: 10)
      discount2 = m1.bulk_discounts.create!(name: 'B', percentage: 0.20, quantity: 20)
      discount3 = m1.bulk_discounts.create!(name: 'C', percentage: 0.30, quantity: 30)
      discount4 = m2.bulk_discounts.create!(name: 'D', percentage: 0.30, quantity: 10)
      discount5 = m2.bulk_discounts.create!(name: 'E', percentage: 0.25, quantity: 15)

      ii_1 = InvoiceItem.create!(invoice_id: i1.id, item_id: item_1.id, quantity: 12, unit_price: 10, status: 0)
      ii_1 = InvoiceItem.create!(invoice_id: i1.id, item_id: item_2.id, quantity: 12, unit_price: 10, status: 0)
      ii_2 = InvoiceItem.create!(invoice_id: i1.id, item_id: item_2.id, quantity: 20, unit_price: 10, status: 1)
      ii_3 = InvoiceItem.create!(invoice_id: i1.id, item_id: item_3.id, quantity: 30, unit_price: 10, status: 2)

      ii_4 = InvoiceItem.create!(invoice_id: i4.id, item_id: item_4.id, quantity: 12, unit_price: 10, status: 0)
      ii_5 = InvoiceItem.create!(invoice_id: i4.id, item_id: item_5.id, quantity: 5, unit_price: 10, status: 1)
      ii_6 = InvoiceItem.create!(invoice_id: i4.id, item_id: item_6.id, quantity: 15, unit_price: 10, status: 2)

      expect(i1.check_discount(ii_1.quantity, item_1.id)).to eq(108.0)
      expect(i1.check_discount(ii_2.quantity, item_2.id)).to eq(128.0)
      expect(i1.check_discount(ii_3.quantity, item_3.id)).to eq(105.0)
      expect(i4.check_discount(ii_4.quantity, item_4.id)).to eq(126.0)
      expect(i4.check_discount(ii_5.quantity, item_5.id)).to eq(50.0)
      expect(i4.check_discount(ii_6.quantity, item_6.id)).to eq(52.5)
    end
    it 'it returns total revenue after discount' do
      m1 = Merchant.create!(name: 'Merchant 1')
      m2 = Merchant.create!(name: 'Merchant 2')

      c1 = Customer.create!(first_name: 'Yo', last_name: 'Yoz')
      c2 = Customer.create!(first_name: 'Hey', last_name: 'Heyz')

      i1 = Invoice.create!(merchant_id: m1.id, customer_id: c1.id, status: 2, created_at: "2012-03-12 14:54:09")
      i2 = Invoice.create!(merchant_id: m1.id, customer_id: c1.id, status: 2, created_at: "2012-09-06 14:54:09")
      i3 = Invoice.create!(merchant_id: m1.id, customer_id: c2.id, status: 2, created_at: "2012-03-28 14:54:09")

      i4 = Invoice.create!(merchant_id: m2.id, customer_id: c1.id, status: 2, created_at: "2012-03-12 14:54:09")
      i5 = Invoice.create!(merchant_id: m2.id, customer_id: c1.id, status: 2, created_at: "2012-09-06 14:54:09")
      i6 = Invoice.create!(merchant_id: m2.id, customer_id: c2.id, status: 2, created_at: "2012-03-28 14:54:09")

      item_1 = Item.create!(name: 'pondering', description: 'hmmmm', unit_price: 10, merchant_id: m1.id)
      item_2 = Item.create!(name: 'thinking', description: 'hurts', unit_price: 8, merchant_id: m1.id)
      item_3 = Item.create!(name: 'best', description: 'aint this fun', unit_price: 5, merchant_id: m1.id)
      item_4 = Item.create!(name: 'pondering', description: 'hmmmm', unit_price: 15, merchant_id: m2.id)
      item_5 = Item.create!(name: 'thinking', description: 'hurts', unit_price: 10, merchant_id: m2.id)
      item_6 = Item.create!(name: 'best', description: 'aint this fun', unit_price: 5, merchant_id: m2.id)

      discount1 = m1.bulk_discounts.create!(name: 'A', percentage: 0.10, quantity: 10)
      discount2 = m1.bulk_discounts.create!(name: 'B', percentage: 0.20, quantity: 20)
      discount3 = m1.bulk_discounts.create!(name: 'C', percentage: 0.30, quantity: 30)
      discount4 = m2.bulk_discounts.create!(name: 'D', percentage: 0.30, quantity: 10)
      discount5 = m2.bulk_discounts.create!(name: 'E', percentage: 0.25, quantity: 15)

      ii_1 = InvoiceItem.create!(invoice_id: i1.id, item_id: item_1.id, quantity: 12, unit_price: 10, status: 0)
      ii_1 = InvoiceItem.create!(invoice_id: i1.id, item_id: item_2.id, quantity: 12, unit_price: 10, status: 0)
      ii_2 = InvoiceItem.create!(invoice_id: i1.id, item_id: item_2.id, quantity: 20, unit_price: 10, status: 1)
      ii_3 = InvoiceItem.create!(invoice_id: i1.id, item_id: item_3.id, quantity: 30, unit_price: 10, status: 2)

      ii_4 = InvoiceItem.create!(invoice_id: i4.id, item_id: item_4.id, quantity: 12, unit_price: 10, status: 0)
      ii_5 = InvoiceItem.create!(invoice_id: i4.id, item_id: item_5.id, quantity: 5, unit_price: 10, status: 1)
      ii_6 = InvoiceItem.create!(invoice_id: i4.id, item_id: item_6.id, quantity: 15, unit_price: 10, status: 2)

      expect(i1.discounted_total_revenue).to eq(427.4)
      expect(i4.discounted_total_revenue).to eq(228.5)
    end
    it 'total' do
      m1 = Merchant.create!(name: 'Merchant 1')
      m2 = Merchant.create!(name: 'Merchant 2')

      c1 = Customer.create!(first_name: 'Yo', last_name: 'Yoz')
      c2 = Customer.create!(first_name: 'Hey', last_name: 'Heyz')

      i1 = Invoice.create!(merchant_id: m1.id, customer_id: c1.id, status: 2, created_at: "2012-03-12 14:54:09")
      i2 = Invoice.create!(merchant_id: m1.id, customer_id: c1.id, status: 2, created_at: "2012-09-06 14:54:09")
      i3 = Invoice.create!(merchant_id: m1.id, customer_id: c2.id, status: 2, created_at: "2012-03-28 14:54:09")

      i4 = Invoice.create!(merchant_id: m2.id, customer_id: c1.id, status: 2, created_at: "2012-03-12 14:54:09")
      i5 = Invoice.create!(merchant_id: m2.id, customer_id: c1.id, status: 2, created_at: "2012-09-06 14:54:09")
      i6 = Invoice.create!(merchant_id: m2.id, customer_id: c2.id, status: 2, created_at: "2012-03-28 14:54:09")

      item_1 = Item.create!(name: 'pondering', description: 'hmmmm', unit_price: 10, merchant_id: m1.id)
      item_2 = Item.create!(name: 'thinking', description: 'hurts', unit_price: 8, merchant_id: m1.id)
      item_3 = Item.create!(name: 'best', description: 'aint this fun', unit_price: 5, merchant_id: m1.id)
      item_4 = Item.create!(name: 'pondering', description: 'hmmmm', unit_price: 15, merchant_id: m2.id)
      item_5 = Item.create!(name: 'thinking', description: 'hurts', unit_price: 10, merchant_id: m2.id)
      item_6 = Item.create!(name: 'best', description: 'aint this fun', unit_price: 5, merchant_id: m2.id)

      discount1 = m1.bulk_discounts.create!(name: 'A', percentage: 0.10, quantity: 10)
      discount2 = m1.bulk_discounts.create!(name: 'B', percentage: 0.20, quantity: 20)
      discount3 = m1.bulk_discounts.create!(name: 'C', percentage: 0.30, quantity: 30)
      discount4 = m2.bulk_discounts.create!(name: 'D', percentage: 0.30, quantity: 10)
      discount5 = m2.bulk_discounts.create!(name: 'E', percentage: 0.25, quantity: 15)

      ii_1 = InvoiceItem.create!(invoice_id: i1.id, item_id: item_1.id, quantity: 12, unit_price: 10, status: 0)
      ii_1 = InvoiceItem.create!(invoice_id: i1.id, item_id: item_2.id, quantity: 12, unit_price: 10, status: 0)
      ii_2 = InvoiceItem.create!(invoice_id: i1.id, item_id: item_2.id, quantity: 20, unit_price: 10, status: 1)
      ii_3 = InvoiceItem.create!(invoice_id: i1.id, item_id: item_3.id, quantity: 30, unit_price: 10, status: 2)

      ii_4 = InvoiceItem.create!(invoice_id: i4.id, item_id: item_4.id, quantity: 12, unit_price: 10, status: 0)
      ii_5 = InvoiceItem.create!(invoice_id: i4.id, item_id: item_5.id, quantity: 5, unit_price: 10, status: 1)
      ii_6 = InvoiceItem.create!(invoice_id: i4.id, item_id: item_6.id, quantity: 15, unit_price: 10, status: 2)

      expect(i1.total(item_1.id, discount1.percentage, ii_1.quantity)).to eq(108)
    end
  end
end
