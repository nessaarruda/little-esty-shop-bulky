require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end
  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
  end
  describe "class methods" do
    it "incomplete_invoices" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @merchant2 = Merchant.create!(name: 'Jewelry')
      @merch1_disc1 = BulkDiscount.create!(name: "Hair Care Discount 1", quantity: 9, percentage: 10, merchant_id: @merchant1.id)
      @merch1_disc2 = BulkDiscount.create!(name: "Hair Care Discount 2", quantity: 14, percentage: 20, merchant_id: @merchant1.id)
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
      @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
      @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
      @item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: @merchant1.id)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id)
      @item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 300, merchant_id: @merchant2.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
      @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
      @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
      @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
      @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Coon')
      @invoice_1 = Invoice.create!(merchant_id: @merchant1.id, customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @invoice_4 = Invoice.create!(merchant_id: @merchant1.id, customer_id: @customer_3.id, status: 2, created_at: "2012-02-28 14:54:09")
      @invoice_8 = Invoice.create!(merchant_id: @merchant2.id, customer_id: @customer_6.id, status: 1)
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2)
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 15, unit_price: 30, status: 0, created_at: "2012-03-28 14:54:09")
      @ii_3 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_3.id, quantity: 5, unit_price: 5, status: 1, created_at: "2012-02-28 14:54:09")
      @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_3.id, quantity: 3, unit_price: 5, status: 1, created_at: "2012-04-28 14:54:09")
      @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
      @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_4.id)
      expect(InvoiceItem.incomplete_invoices).to eq([@invoice_4, @invoice_1])
    end
    it 'eligible_for_discount' do
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

      id1 = ii_1.id
      id2 = ii_2.id
      id3 = ii_3.id

      expect(ii_1.qualified_discount).to eq(discount1)
    end
  end
end
