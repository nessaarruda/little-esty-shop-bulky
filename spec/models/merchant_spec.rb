require 'rails_helper'

describe Merchant do
  describe 'validations' do
    it { should validate_presence_of :name }
  end
  describe 'relationships' do
    it { should have_many :invoices }
    it { should have_many :items }
    it { should have_many :bulk_discounts }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:invoice_items).through(:items) }
  end

  describe 'instance methods' do
    before :each do
      @m1 = Merchant.create!(name: 'Merchant 1')
      @m2 = Merchant.create!(name: 'Merchant 2')
      @m3 = Merchant.create!(name: 'Merchant 3', status: 1)
      @m4 = Merchant.create!(name: 'Merchant 4')
      @m5 = Merchant.create!(name: 'Merchant 5')
      @m6 = Merchant.create!(name: 'Merchant 6')


      @c1 = Customer.create!(first_name: 'Yo', last_name: 'Yoz')
      @c2 = Customer.create!(first_name: 'Hey', last_name: 'Heyz')
      @c3 = Customer.create!(first_name: 'Sup', last_name: 'Sop')
      @c4 = Customer.create!(first_name: 'Whaddup', last_name: 'Clouds')
      @c5 = Customer.create!(first_name: 'Tifa', last_name: 'Lockhart')
      @c6 = Customer.create!(first_name: 'Spongebob', last_name: 'Squarepants')

      @i1 = Invoice.create!(merchant_id: @m1.id, customer_id: @c1.id, status: 2, created_at: "2012-03-12 14:54:09")
      @i2 = Invoice.create!(merchant_id: @m1.id, customer_id: @c1.id, status: 2, created_at: "2012-09-06 14:54:09")
      @i3 = Invoice.create!(merchant_id: @m1.id, customer_id: @c2.id, status: 2, created_at: "2012-03-28 14:54:09")
      @i4 = Invoice.create!(merchant_id: @m1.id, customer_id: @c2.id, status: 2)
      @i5 = Invoice.create!(merchant_id: @m2.id, customer_id: @c3.id, status: 2)
      @i6 = Invoice.create!(merchant_id: @m2.id, customer_id: @c3.id, status: 2)
      @i7 = Invoice.create!(merchant_id: @m3.id, customer_id: @c1.id, status: 2)
      @i8 = Invoice.create!(merchant_id: @m3.id, customer_id: @c3.id, status: 2)
      @i9 = Invoice.create!(merchant_id: @m3.id, customer_id: @c4.id, status: 2)
      @i10 = Invoice.create!(merchant_id: @m4.id, customer_id: @c4.id, status: 2)
      @i11 = Invoice.create!(merchant_id: @m4.id, customer_id: @c6.id, status: 2)
      @i12 = Invoice.create!(merchant_id: @m5.id, customer_id: @c6.id, status: 2)
      @i13 = Invoice.create!(merchant_id: @m1.id, customer_id: @c3.id, status: 2, created_at: "2012-01-04 14:54:09")
      @i14 = Invoice.create!(merchant_id: @m1.id, customer_id: @c4.id, status: 2, created_at: "2012-03-28 14:54:09")
      @i15 = Invoice.create!(merchant_id: @m1.id, customer_id: @c6.id, status: 2, created_at: "2012-03-28 14:54:09")

      @item_1 = Item.create!(name: 'pondering', description: 'hmmmm', unit_price: 10, merchant_id: @m1.id)
      @item_2 = Item.create!(name: 'thinking', description: 'hurts', unit_price: 8, merchant_id: @m2.id)
      @item_3 = Item.create!(name: 'best', description: 'aint this fun', unit_price: 5, merchant_id: @m3.id)
      @item_4 = Item.create!(name: 'test', description: 'lalala', unit_price: 6, merchant_id: @m4.id)
      @item_5 = Item.create!(name: 'rest', description: 'dont test me', unit_price: 12, merchant_id: @m5.id)
      @item_6 = Item.create!(name: 'crunchy crunch', description: 'delicious', unit_price: 7, merchant_id: @m1.id)
      @item_7 = Item.create!(name: 'just vibin', description: 'pure vibes man', unit_price: 13, merchant_id: @m1.id)
      @item_8 = Item.create!(name: 'bet', description: 'no cap', unit_price: 4, merchant_id: @m1.id)
      @item_9 = Item.create!(name: 'wiggle', description: 'wiggle wobble', unit_price: 2, merchant_id: @m1.id)
      @item_10 = Item.create!(name: 'jiggle', description: 'driving down a bumpy road', unit_price: 30, merchant_id: @m1.id)

      @discount1 = @m1.bulk_discounts.create!(name: 'A', percentage: 0.10, quantity: 10)
      @discount2 = @m1.bulk_discounts.create!(name: 'B', percentage: 0.20, quantity: 20)
      @discount3 = @m1.bulk_discounts.create!(name: 'C', percentage: 0.30, quantity: 30)

      @discount4 = @m2.bulk_discounts.create!(name: 'D', percentage: 0.10, quantity: 10)
      @discount5 = @m2.bulk_discounts.create!(name: 'E', percentage: 0.20, quantity: 20)
      @discount6 = @m2.bulk_discounts.create!(name: 'F', percentage: 0.30, quantity: 30)

      @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 12, unit_price: 10, status: 0)
      @ii_2 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_1.id, quantity: 6, unit_price: 8, status: 1)
      @ii_3 = InvoiceItem.create!(invoice_id: @i3.id, item_id: @item_9.id, quantity: 16, unit_price: 5, status: 2)
      @ii_4 = InvoiceItem.create!(invoice_id: @i5.id, item_id: @item_2.id, quantity: 2, unit_price: 5, status: 2)
      @ii_5 = InvoiceItem.create!(invoice_id: @i6.id, item_id: @item_2.id, quantity: 10, unit_price: 5, status: 2)
      @ii_6 = InvoiceItem.create!(invoice_id: @i7.id, item_id: @item_3.id, quantity: 7, unit_price: 5, status: 2)
      @ii_7 = InvoiceItem.create!(invoice_id: @i8.id, item_id: @item_3.id, quantity: 7, unit_price: 5, status: 2)
      @ii_8 = InvoiceItem.create!(invoice_id: @i9.id, item_id: @item_3.id, quantity: 7, unit_price: 5, status: 2)
      @ii_9 = InvoiceItem.create!(invoice_id: @i10.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 2)
      @ii_10 = InvoiceItem.create!(invoice_id: @i12.id, item_id: @item_5.id, quantity: 1, unit_price: 5, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_7.id, quantity: 1, unit_price: 5, status: 2)
      @ii_12 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_8.id, quantity: 1, unit_price: 5, status: 2)
      @ii_13 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_9.id, quantity: 1, unit_price: 5, status: 2)
      @ii_14 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_9.id, quantity: 1, unit_price: 5, status: 2)
      @ii_15 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_10.id, quantity: 1, unit_price: 5, status: 2)
      @ii_16 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_10.id, quantity: 1, unit_price: 5, status: 2)
      @ii_17 = InvoiceItem.create!(invoice_id: @i15.id, item_id: @item_1.id, quantity: 12, unit_price: 10, status: 2)
      @ii_18 = InvoiceItem.create!(invoice_id: @i14.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 1)
      @ii_19 = InvoiceItem.create!(invoice_id: @i13.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 1)

      @t1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @i1.id)
      @t2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @i2.id)
      @t3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @i3.id)
      @t4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @i5.id)
      @t5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @i6.id)
      @t6 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @i7.id)
      @t7 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @i8.id)
      @t8 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @i10.id)
      @t9 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @i11.id)
      @t10 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @i12.id)
      @t11 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @i13.id)
      @t12 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @i14.id)
      @t13 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @i15.id)


    end

    it 'can list items ready to ship' do
      expected = @m1.ordered_items_to_ship.map do |item|
        item.name
      end
      expect(expected.sort).to eq([@item_1.name, @item_1.name, @item_1.name, @item_1.name].sort)
    end

    it 'shows a list of favorite customers' do
      expected = @m1.favorite_customers.map do |customer|
        customer[:first_name]
      end
      expect(expected).to eq([@c1.first_name, @c2.first_name, @c3.first_name, @c4.first_name, @c6.first_name])
    end

    it 'top_5_items' do
      expect(@m1.top_5_items).to eq([@item_1, @item_9, @item_10, @item_7, @item_8])
    end

    it 'can list the top 5 merchants' do
      expected = Merchant.top_merchants.map do |m|
        m[:name]
      end
      expect(expected).to eq([@m1.name, @m3.name, @m2.name, @m4.name, @m5.name])
    end

    it 'can list the merchants best day' do
      expect(@m1.best_day).to eq(@i3.created_at.to_date)
    end
    
  end
end
