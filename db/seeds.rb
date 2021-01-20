InvoiceItem.destroy_all
Merchant.destroy_all
Customer.destroy_all
Invoice.destroy_all
BulkDiscount.destroy_all
Transaction.destroy_all
Item.destroy_all


@m1 = Merchant.create!(name: 'Merchant 1')
@m2 = Merchant.create!(name: 'Merchant 2')

@c1 = Customer.create!(first_name: 'Bilbo', last_name: 'Baggins')
@c2 = Customer.create!(first_name: 'Frodo', last_name: 'Baggins')
@c3 = Customer.create!(first_name: 'Samwise', last_name: 'Gamgee')
@c4 = Customer.create!(first_name: 'Aragorn', last_name: 'Elessar')
@c5 = Customer.create!(first_name: 'Arwen', last_name: 'Undomiel')
@c6 = Customer.create!(first_name: 'Legolas', last_name: 'Greenleaf')

@i1 = Invoice.create!(merchant_id: @m1.id, customer_id: @c1.id, status: 2)
@i2 = Invoice.create!(merchant_id: @m1.id, customer_id: @c1.id, status: 2)
@i3 = Invoice.create!(merchant_id: @m1.id, customer_id: @c2.id, status: 2)
@i4 = Invoice.create!(merchant_id: @m2.id, customer_id: @c3.id, status: 2)
@i5 = Invoice.create!(merchant_id: @m2.id, customer_id: @c4.id, status: 2)

@t1 = Transaction.create!(invoice_id: @i1.id, credit_card_number: 00000, credit_card_expiration_date: 00000, result: 1)
@t2 = Transaction.create!(invoice_id: @i2.id, credit_card_number: 00000, credit_card_expiration_date: 00000, result: 1)
@t3 = Transaction.create!(invoice_id: @i3.id, credit_card_number: 00000, credit_card_expiration_date: 00000, result: 1)
@t4 = Transaction.create!(invoice_id: @i4.id, credit_card_number: 00000, credit_card_expiration_date: 00000, result: 1)
@t5 = Transaction.create!(invoice_id: @i5.id, credit_card_number: 00000, credit_card_expiration_date: 00000, result: 1)

@item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10, merchant_id: @m1.id)
@item_2 = Item.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8, merchant_id: @m1.id)
@item_3 = Item.create!(name: 'Brush', description: 'This takes out tangles', unit_price: 5, merchant_id: @m2.id)

@ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
@ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
@ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
@ii_4 = InvoiceItem.create!(invoice_id: @i3.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 1)

@discount1 = @m1.bulk_discounts.create!(name: 'A', percentage: 0.10, quantity: 10)
@discount2 = @m1.bulk_discounts.create!(name: 'B', percentage: 0.20, quantity: 20)
@discount3 = @m2.bulk_discounts.create!(name: 'C', percentage: 0.30, quantity: 30)
