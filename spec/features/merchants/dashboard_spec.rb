require 'rails_helper'

RSpec.describe "merchant dashboard", type: :feature do
  before :each do
    @merch_1 = Merchant.create(name: "Schroeder-Jerde" )
    @merch_2 = Merchant.create(name: "Klein, Rempel and Jones")

    @item_1 = @merch_1.items.create!(name: "Two-Leg Pantaloons", description: "pants built for people with two legs", unit_price: 5000)
    @item_2 = @merch_1.items.create!(name: "Two-Leg Shorts", description: "shorts built for people with two legs", unit_price: 3000)
    @item_3 = @merch_1.items.create!(name: "Hat", description: "hat built for people with two legs and one head", unit_price: 6000)
    @item_4 = @merch_2.items.create!(name: "Shirt", description: "shirt for people", unit_price: 50000)

    @cust_1 = Customer.create!(first_name: "Debbie", last_name: "Twolegs")
    @cust_2 = Customer.create!(first_name: "Tommy", last_name: "Doubleleg")

    @invoice_1 = @cust_1.invoices.create!(status: 1)
    @invoice_2 = @cust_1.invoices.create!(status: 1)
    @invoice_3 = @cust_1.invoices.create!(status: 1)
    @invoice_4 = @cust_2.invoices.create!(status: 1)
    @invoice_5 = @cust_2.invoices.create!(status: 1)
    @invoice_6 = @cust_2.invoices.create!(status: 1)

    @bulk_discount1 = BulkDiscount.create!(name: "%20 Off", percent_off: 0.1, threshold: 10, merchant_id: @merch_1.id)

    visit "/merchants/#{@merch_1.id}/dashboard"
  end

  it "shows name of merchant" do
    expect(page).to have_content("Schroeder-Jerde")
    expect(page).to_not have_content("Klein, Rempel and Jones")
  end

  it "has links to merchant items index and merchant invoices index" do
    expect(page).to have_link("My Items", href: "/merchants/#{@merch_1.id}/items")
    expect(page).to have_link("My Invoices", href: "/merchants/#{@merch_1.id}/invoices")
    expect(page).to_not have_link("My Items", href: "/merchants/#{@merch_2.id}/items")
    expect(page).to_not have_link("My Invoices", href: "/merchants/#{@merch_2.id}/invoices")
  end

  it "shows list of items ready to ship with their invoice id" do
    ii_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: @item_1.unit_price, status: 0)
    ii_2 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_2.id, quantity: 1, unit_price: @item_1.unit_price, status: 1)
    ii_3 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_2.id, quantity: 1, unit_price: @item_2.unit_price, status: 2)
    ii_4 = InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_2.id, quantity: 1, unit_price: @item_3.unit_price, status: 2)
    ii_5 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_4.id, quantity: 1, unit_price: @item_1.unit_price, status: 1)
    ii_6 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_4.id, quantity: 1, unit_price: @item_2.unit_price, status: 1)
    ii_7 = InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice_6.id, quantity: 1, unit_price: @item_4.unit_price, status: 1)

    visit "/merchants/#{@merch_1.id}/dashboard"

    expect(page).to have_content("Items Ready To Ship")

    within("#item-0") do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@invoice_1.id)
      expect(page).to_not have_content(@item_2.name)
      expect(page).to_not have_content(@invoice_2.id)
      click_link "Invoice ##{@invoice_1.id}"
      expect(current_path).to eq("/merchants/#{@merch_1.id}/invoices/#{@invoice_1.id}")
      visit "/merchants/#{@merch_1.id}/dashboard"
    end
    within("#item-1") do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@invoice_2.id)
      expect(page).to_not have_content(@item_2.name)
      expect(page).to_not have_content(@invoice_1.id)
      click_link "Invoice ##{@invoice_2.id}"
      expect(current_path).to eq("/merchants/#{@merch_1.id}/invoices/#{@invoice_2.id}")
      visit "/merchants/#{@merch_1.id}/dashboard"
    end
    within("#item-2") do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@invoice_4.id)
      expect(page).to_not have_content(@item_4.name)
      expect(page).to_not have_content(@invoice_1.id)
      click_link "Invoice ##{@invoice_4.id}"
      expect(current_path).to eq("/merchants/#{@merch_1.id}/invoices/#{@invoice_4.id}")
      visit "/merchants/#{@merch_1.id}/dashboard"
    end
    within("#item-3") do
      expect(page).to have_content(@item_2.name)
      expect(page).to have_content(@invoice_4.id)
      expect(page).to_not have_content(@item_4.name)
      expect(page).to_not have_content(@invoice_2.id)
      click_link "Invoice ##{@invoice_4.id}"
      expect(current_path).to eq("/merchants/#{@merch_1.id}/invoices/#{@invoice_4.id}")
      visit "/merchants/#{@merch_1.id}/dashboard"
    end
  end

  it 'displays invoice date created next to item in items ready to ship and orders by oldest first' do
    ii_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: @item_1.unit_price, status: 0, created_at: "2022-05-30 22:07:10")
    ii_2 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_2.id, quantity: 1, unit_price: @item_1.unit_price, status: 1, created_at: "2022-04-30 22:07:10")
    ii_3 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_2.id, quantity: 1, unit_price: @item_2.unit_price, status: 2, created_at: "2022-05-30 22:07:10")
    ii_4 = InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_2.id, quantity: 1, unit_price: @item_3.unit_price, status: 2, created_at: "2022-05-30 22:07:10")
    ii_5 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_4.id, quantity: 1, unit_price: @item_1.unit_price, status: 1, created_at: "2022-04-18 20:07:10")
    ii_6 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_4.id, quantity: 1, unit_price: @item_2.unit_price, status: 1, created_at: "2022-05-30 15:07:10")
    ii_7 = InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice_6.id, quantity: 1, unit_price: @item_4.unit_price, status: 1, created_at: "2022-02-30 22:07:10")

    visit "/merchants/#{@merch_1.id}/dashboard"

    within("#item-0") do
      expect(page).to have_content("Monday, April 18, 2022")
      expect(page).to_not have_content("Monday, May 30, 2022")
      expect(page).to_not have_content("Saturday, April 30, 2022")
      expect(page).to_not have_content("Monday, May 30, 2022")
    end
    within("#item-1") do
      expect(page).to have_content("Saturday, April 30, 2022")
      expect(page).to_not have_content("Monday, April 18, 2022")
      expect(page).to_not have_content("Monday, May 30, 2022")
      expect(page).to_not have_content("Monday, May 30, 2022")
    end
    within("#item-2") do
      expect(page).to have_content("Monday, May 30, 2022")
      expect(page).to have_content(@item_2.name)
      expect(page).to_not have_content("Monday, April 18, 2022")
      expect(page).to_not have_content("Saturday, April 30, 2022")
    end
    within("#item-3") do
      expect(page).to have_content("Monday, May 30, 2022")
      expect(page).to have_content(@item_1.name)
      expect(page).to_not have_content("Monday, April 18, 2022")
      expect(page).to_not have_content("Saturday, April 30, 2022")
    end

    expect("Monday, April 18, 2022").to appear_before("Saturday, April 30, 2022")
    expect("Saturday, April 30, 2022").to appear_before("Monday, May 30, 2022")
  end

  it 'displays the top 5 customers for a merchant' do
    item_5 = @merch_1.items.create!(name: "Stainless Steel, 5-Pocket Jean", description: "Shorts of Steel", unit_price: 3000000)
    item_6 = @merch_1.items.create!(name: "String of Numbers", description: "54921752964273", unit_price: 100)
    item_7 = @merch_2.items.create!(name: "Shirt", description: "shirt for people", unit_price: 50000)


    cust_3 = Customer.create!(first_name: "Brian", last_name: "Twinlegs")
    cust_4 = Customer.create!(first_name: "Jared", last_name: "Goffleg")
    cust_5 = Customer.create!(first_name: "Pistol", last_name: "Pete")
    cust_6 = Customer.create!(first_name: "Bronson", last_name: "Shmonson")
    cust_7 = Customer.create!(first_name: "Anten", last_name: "Branden")
    cust_8 = Customer.create!(first_name: "Anthony", last_name: "Smith")

    invoice_7 = @cust_2.invoices.create!(status: 1)
    invoice_8 = cust_3.invoices.create!(status: 1)
    invoice_9 = cust_3.invoices.create!(status: 1)
    invoice_10 = cust_5.invoices.create!(status: 1)
    invoice_11 = cust_6.invoices.create!(status: 1)
    invoice_12 = cust_6.invoices.create!(status: 1)
    invoice_13 = cust_6.invoices.create!(status: 1)
    invoice_14 = cust_7.invoices.create!(status: 1)
    invoice_15 = cust_7.invoices.create!(status: 2)
    invoice_16 = cust_7.invoices.create!(status: 2)
    invoice_17 = cust_8.invoices.create!(status: 1)

    ii_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
    ii_2 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_2.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
    ii_3 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_3.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
    ii_4 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_4.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
    ii_5 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_5.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
    ii_6 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_6.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
    ii_7 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: invoice_7.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
    ii_8 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: invoice_8.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
    ii_9 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: invoice_9.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
    ii_10 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: invoice_10.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)

    ii_11 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: invoice_11.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
    ii_12 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: invoice_12.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
    ii_13 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: invoice_13.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
    ii_14 = InvoiceItem.create!(item_id: @item_4.id, invoice_id: invoice_14.id, quantity: 500, unit_price: @item_4.unit_price, status: 2)
    ii_15 = InvoiceItem.create!(item_id: item_6.id, invoice_id: invoice_14.id, quantity: 1, unit_price: @item_4.unit_price, status: 2)
    ii_16 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: invoice_14.id, quantity: 30, unit_price: @item_1.unit_price, status: 2)
    ii_17 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: invoice_14.id, quantity: 30, unit_price: @item_2.unit_price, status: 2)
    ii_18 = InvoiceItem.create!(item_id: @item_3.id, invoice_id: invoice_14.id, quantity: 30, unit_price: @item_3.unit_price, status: 2)
    ii_19 = InvoiceItem.create!(item_id: item_5.id, invoice_id: invoice_15.id, quantity: 700, unit_price: item_5.unit_price, status: 2)
    ii_20 = InvoiceItem.create!(item_id: item_7.id, invoice_id: invoice_16.id, quantity: 700, unit_price: item_7.unit_price, status: 2)
    ii_21 = InvoiceItem.create!(item_id: item_7.id, invoice_id: invoice_17.id, quantity: 300, unit_price: item_7.unit_price, status: 2)

    transaction_1 = @invoice_1.transactions.create!(credit_card_number: 4039485738495837, credit_card_expiration_date: "1", result: "success")
    transaction_2 = @invoice_2.transactions.create!(credit_card_number: 4039485738495837, credit_card_expiration_date: "1", result: "success")
    transaction_3 = @invoice_3.transactions.create!(credit_card_number: 4039485738495837, credit_card_expiration_date: "1", result: "success")
    transaction_4 = @invoice_4.transactions.create!(credit_card_number: 4847583748374837, credit_card_expiration_date: "1", result: "success")
    transaction_5 = @invoice_5.transactions.create!(credit_card_number: 4847583748374837, credit_card_expiration_date: "1", result: "success")
    transaction_6 = @invoice_6.transactions.create!(credit_card_number: 4847583748374837, credit_card_expiration_date: "1", result: "success")
    transaction_7 = invoice_7.transactions.create!(credit_card_number: 4364756374652636, credit_card_expiration_date: "1", result: "success")
    transaction_8 = invoice_8.transactions.create!(credit_card_number: 4364756374652636, credit_card_expiration_date: "1", result: "success")
    transaction_9 = invoice_9.transactions.create!(credit_card_number: 4928294837461125, credit_card_expiration_date: "1", result: "success")
    transaction_10 = invoice_10.transactions.create!(credit_card_number: 4928294837461125, credit_card_expiration_date: "1", result: "success")
    transaction_11 = invoice_11.transactions.create!(credit_card_number: 4738473664751832, credit_card_expiration_date: "1", result: "success")
    transaction_12 = invoice_12.transactions.create!(credit_card_number: 4738473664751832, credit_card_expiration_date: "1", result: "success")
    transaction_13 = invoice_13.transactions.create!(credit_card_number: 4023948573948293, credit_card_expiration_date: "1", result: "success")
    transaction_14 = invoice_14.transactions.create!(credit_card_number: 4023948573948293, credit_card_expiration_date: "1", result: "failure")
    transaction_15 = invoice_15.transactions.create!(credit_card_number: 4023948573948293, credit_card_expiration_date: "1", result: "success")
    transaction_16 = invoice_17.transactions.create!(credit_card_number: 4023948573948394, credit_card_expiration_date: "1", result: "success")

    visit "/merchants/#{@merch_1.id}/dashboard"

    expect(page).to have_content("Favorite Customers")
    expect("1. Tommy Doubleleg").to appear_before("2. Debbie Twolegs")
    expect("2. Debbie Twolegs").to appear_before("3. Bronson Shmonson")
    expect("3. Bronson Shmonson").to appear_before("4. Brian Twinlegs")
    expect("4. Brian Twinlegs").to appear_before("5. Pistol Pete")
    within("#customer-0") do
      expect(page).to have_content("1. Tommy Doubleleg - 4")
      expect(page).to_not have_content("Bronson Shmonson - 3")
      expect(page).to_not have_content("Debbie Twolegs - 3")
      expect(page).to_not have_content("Pistol Pete - 2")
      expect(page).to_not have_content("Brian Twinlegs - 2")
    end
    within("#customer-1") do
      expect(page).to have_content("2. Debbie Twolegs - 3")
      expect(page).to_not have_content("Tommy Doubleleg - 4")
      expect(page).to_not have_content("Bronson Shmonson - 3")
      expect(page).to_not have_content("Pistol Pete - 1")
      expect(page).to_not have_content("Brian Twinlegs - 2")
    end
    within("#customer-2") do
      expect(page).to have_content("3. Bronson Shmonson - 3")
      expect(page).to_not have_content("Tommy Doubleleg - 4")
      expect(page).to_not have_content("Debbie Twolegs - 3")
      expect(page).to_not have_content("Brian Twinlegs - 2")
      expect(page).to_not have_content("Pistol Pete - 1")
    end
    within("#customer-3") do
      expect(page).to have_content("4. Brian Twinlegs - 2")
      expect(page).to_not have_content("Pistol Pete - 1")
      expect(page).to_not have_content("Tommy Doubleleg - 4")
      expect(page).to_not have_content("Debbie Twolegs - 3")
      expect(page).to_not have_content("Bronson Shmonson - 3")
    end
    within("#customer-4") do
      expect(page).to have_content("5. Pistol Pete - 1")
      expect(page).to_not have_content("Tommy Doubleleg - 4")
      expect(page).to_not have_content("Debbie Twolegs - 3")
      expect(page).to_not have_content("Bronson Shmonson - 3")
      expect(page).to_not have_content("Brian Twinlegs - 2")
    end
  end

  it "has a link to view discounts" do
    visit "/merchants/#{@merch_1.id}/dashboard"

    expect(page).to have_link("View All Discounts")
    click_link "View All Discounts"
    expect(current_path).to eq(merchant_bulk_discounts_path(@merch_1))
  end

  it 'has links to each discounts show page' do
    visit merchant_bulk_discounts_path(@merch_1)

    expect(page).to have_link(@bulk_discount1.name)
    click_link "#{@bulk_discount1.name}"
    expect(current_path).to eq(merchant_bulk_discount_path(@merch_1, @bulk_discount1))
  end

end
