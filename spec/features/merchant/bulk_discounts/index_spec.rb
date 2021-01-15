require 'rails_helper'

RSpec.describe 'merchant bulk discounts index' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')

    @discount1 = @merchant1.bulk_discounts.create!(percentage: 0.10, quantity: 10)
    @discount2 = @merchant1.bulk_discounts.create!(percentage: 0.20, quantity: 20)
    @discount3 = @merchant1.bulk_discounts.create!(percentage: 0.30, quantity: 30)

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Coon')

    @invoice_1 = Invoice.create!(merchant_id: @merchant1.id, customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(merchant_id: @merchant1.id, customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(merchant_id: @merchant1.id, customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(merchant_id: @merchant1.id, customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(merchant_id: @merchant1.id, customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(merchant_id: @merchant1.id, customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(merchant_id: @merchant1.id, customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

    visit merchant_bulk_discounts_path(@merchant1)
  end
  it 'I see a link to create a discount' do
    expect(page).to have_link("Create Bulk Discount")

    click_on "Create Bulk Discount"

    fill_in :percentage, with: 0.10
    fill_in :quantity, with: 15

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))

    expect(page).to have_field(:percentage)
    expect(page).to have_field(:quantity)
    expect(page).to have_button(:submit)
    expect(@merchant1.bulk_discounts.count).to eq(3)
    click_on :submit

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
    expect(@merchant1.bulk_discounts.count).to eq(4)
  end
  it 'Next to each discount I see a link to delete it' do
    expect(page).to have_link(:delete)
    expect(@merchant1.bulk_discounts.count).to eq(3)

    first("#discounts-#{@discount1.id}").click_link(:delete)

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
    expect(page).to_not have_content(@discount1.quantity)
    expect(@merchant1.bulk_discounts.count).to eq(2)
  end
end
