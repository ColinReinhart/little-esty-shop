require 'rails_helper'

RSpec.describe "Admin dashboard" do
  before(:each) do
    @merch_1 = Merchant.create!(name: "Two-Legs Fashion")

    @item_1 = @merch_1.items.create!(name: "Two-Leg Pantaloons", description: "pants built for people with two legs", unit_price: 5000)
    @item_2 = @merch_1.items.create!(name: "Two-Leg Shorts", description: "shorts built for people with two legs", unit_price: 3000)
    @item_3 = @merch_1.items.create!(name: "Hat", description: "hat built for people with two legs and one head", unit_price: 6000)
    @item_4 = @merch_1.items.create!(name: "Double Legged Pant", description: "pants built for people with two legs", unit_price: 50000)
    @item_5 = @merch_1.items.create!(name: "Stainless Steel, 5-Pocket Jean", description: "Shorts of Steel", unit_price: 3000000)
    @item_6 = @merch_1.items.create!(name: "String of Numbers", description: "54921752964273", unit_price: 100)

    @cust_1 = Customer.create!(first_name: "Debbie", last_name: "Twolegs")
    @cust_2 = Customer.create!(first_name: "Tommy", last_name: "Doubleleg")
    @cust_3 = Customer.create!(first_name: "Brian", last_name: "Twinlegs")
    @cust_4 = Customer.create!(first_name: "Jared", last_name: "Goffleg")
    @cust_5 = Customer.create!(first_name: "Pistol", last_name: "Pete")
    @cust_6 = Customer.create!(first_name: "Bronson", last_name: "Shmonson")
    @cust_7 = Customer.create!(first_name: "Anten", last_name: "Branden")

    @invoice_1 = @cust_1.invoices.create!(status: 1, created_at: "2022-06-03 17:51:52")
    @invoice_2 = @cust_1.invoices.create!(status: 1, created_at: "2022-05-25 17:51:52")
    @invoice_3 = @cust_1.invoices.create!(status: 1, created_at: "2022-05-20 17:51:52")
    @invoice_4 = @cust_2.invoices.create!(status: 1, created_at: "2022-05-03 17:51:52")
    @invoice_5 = @cust_2.invoices.create!(status: 1)
    @invoice_6 = @cust_2.invoices.create!(status: 1)
    @invoice_7 = @cust_3.invoices.create!(status: 1)
    @invoice_8 = @cust_3.invoices.create!(status: 1)
    @invoice_9 = @cust_4.invoices.create!(status: 1)
    @invoice_10 = @cust_4.invoices.create!(status: 1)
    @invoice_11 = @cust_5.invoices.create!(status: 1)
    @invoice_12 = @cust_5.invoices.create!(status: 1)
    @invoice_13 = @cust_6.invoices.create!(status: 1)
    @invoice_14 = @cust_7.invoices.create!(status: 1)
    @invoice_15 = @cust_7.invoices.create!(status: 2)

    @ii_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: @item_1.unit_price, status: 0)
    @ii_2 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_2.id, quantity: 1, unit_price: @item_1.unit_price, status: 0)
    @ii_3 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_3.id, quantity: 1, unit_price: @item_1.unit_price, status: 0)
    @ii_4 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_4.id, quantity: 1, unit_price: @item_1.unit_price, status: 0)
    @ii_5 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_5.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
    @ii_6 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_6.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
    @ii_7 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_7.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
    @ii_8 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_8.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
    @ii_9 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_9.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
    @ii_10 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_10.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)

    @ii_11 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_11.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
    @ii_12 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_12.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
    @ii_13 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_13.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
    @ii_14 = InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice_14.id, quantity: 500, unit_price: @item_4.unit_price, status: 2)
    @ii_15 = InvoiceItem.create!(item_id: @item_6.id, invoice_id: @invoice_14.id, quantity: 1, unit_price: @item_4.unit_price, status: 2)
    @ii_16 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_14.id, quantity: 30, unit_price: @item_1.unit_price, status: 2)
    @ii_17 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_14.id, quantity: 30, unit_price: @item_2.unit_price, status: 2)
    @ii_18 = InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_14.id, quantity: 30, unit_price: @item_3.unit_price, status: 2)
    @ii_19 = InvoiceItem.create!(item_id: @item_5.id, invoice_id: @invoice_15.id, quantity: 700, unit_price: @item_4.unit_price, status: 2)

    @transaction_1 = @invoice_1.transactions.create!(credit_card_number: 4039485738495837, result: "success")
    @transaction_2 = @invoice_2.transactions.create!(credit_card_number: 4039485738495837, result: "success")
    @transaction_3 = @invoice_3.transactions.create!(credit_card_number: 4039485738495837, result: "success")
    @transaction_4 = @invoice_4.transactions.create!(credit_card_number: 4847583748374837, result: "success")
    @transaction_5 = @invoice_5.transactions.create!(credit_card_number: 4847583748374837, result: "success")
    @transaction_6 = @invoice_6.transactions.create!(credit_card_number: 4847583748374837, result: "success")
    @transaction_7 = @invoice_7.transactions.create!(credit_card_number: 4364756374652636, result: "success")
    @transaction_8 = @invoice_8.transactions.create!(credit_card_number: 4364756374652636, result: "success")
    @transaction_9 = @invoice_9.transactions.create!(credit_card_number: 4928294837461125, result: "success")
    @transaction_10 = @invoice_10.transactions.create!(credit_card_number: 4928294837461125, result: "success")
    @transaction_11 = @invoice_11.transactions.create!(credit_card_number: 4738473664751832, result: "success")
    @transaction_12 = @invoice_12.transactions.create!(credit_card_number: 4738473664751832, result: "success")
    @transaction_13 = @invoice_13.transactions.create!(credit_card_number: 4023948573948293, result: "success")
    @transaction_14 = @invoice_14.transactions.create!(credit_card_number: 4023948573948293, result: "success")
    @transaction_15 = @invoice_15.transactions.create!(credit_card_number: 4023948573948293, result: "success")

    visit admin_path
  end

  it "shows the admin dashboard" do
    expect(page).to have_content "Admin Dashboard"
  end

  it "has links to admin/merchants and admin/invoices" do
    click_link "Merchants"
    expect(current_path).to eq(merchants_path)

    visit admin_path

    click_link "Invoices"
    expect(current_path).to eq(invoices_path)
  end

  it "displays the incomplete invoices and links to that invoices admin show" do
    expect(page).to have_content("Incomplete Invoices")
    expect(page).to have_content(@invoice_1.id)
    expect(page).to have_content(@invoice_2.id)
    expect(page).to have_content(@invoice_3.id)
    expect(page).to have_content(@invoice_4.id)

    expect(page).to_not have_content(@invoice_5.id)
    expect(page).to_not have_content(@invoice_6.id)
    expect(page).to_not have_content(@invoice_7.id)

    click_link "#{@invoice_1.id}"
    expect(current_path).to eq(invoice_path(@invoice_1))
  end

  it "displays the incomplete invoices created at dates and orders them by oldest to youngest" do
    visit '/admin'

    expect("#{@invoice_4.id}").to appear_before("#{@invoice_3.id}")
    expect("#{@invoice_3.id}").to appear_before("#{@invoice_2.id}")
    expect("#{@invoice_2.id}").to appear_before("#{@invoice_1.id}")
    expect(page).to have_content("#{@invoice_4.id} - #{@invoice_4.created_at.strftime("%A, %B %d, %Y")}")
    expect(page).to have_content("#{@invoice_3.id} - #{@invoice_3.created_at.strftime("%A, %B %d, %Y")}")
    expect(page).to have_content("#{@invoice_2.id} - #{@invoice_2.created_at.strftime("%A, %B %d, %Y")}")
    expect(page).to have_content("#{@invoice_1.id} - #{@invoice_1.created_at.strftime("%A, %B %d, %Y")}")
  end

  it 'displays the top 5 customers with the most successful transactions and lists their number of successful transactions next to each' do
    @invoice_16 = @cust_1.invoices.create!(status: 1)
    @invoice_17 = @cust_1.invoices.create!(status: 1)
    @invoice_18 = @cust_1.invoices.create!(status: 1)
    @invoice_19 = @cust_1.invoices.create!(status: 1)
    @invoice_20 = @cust_2.invoices.create!(status: 1)
    @invoice_21 = @cust_2.invoices.create!(status: 1)
    @invoice_22 = @cust_3.invoices.create!(status: 1)
    @invoice_23 = @cust_3.invoices.create!(status: 1)
    @invoice_24 = @cust_3.invoices.create!(status: 1)
    @invoice_25 = @cust_3.invoices.create!(status: 1)
    @invoice_26 = @cust_4.invoices.create!(status: 1)
    @invoice_27 = @cust_4.invoices.create!(status: 1)
    @invoice_28 = @cust_7.invoices.create!(status: 1)

    @transaction_16 = @invoice_16.transactions.create!(credit_card_number: 4023948573948293, result: "success")
    @transaction_17 = @invoice_17.transactions.create!(credit_card_number: 4023948573948293, result: "success")
    @transaction_18 = @invoice_18.transactions.create!(credit_card_number: 4023948573948293, result: "success")
    @transaction_19 = @invoice_19.transactions.create!(credit_card_number: 4023948573948293, result: "success")
    @transaction_20 = @invoice_20.transactions.create!(credit_card_number: 4023948573948293, result: "success")
    @transaction_21 = @invoice_21.transactions.create!(credit_card_number: 4023948573948293, result: "success")
    @transaction_22 = @invoice_22.transactions.create!(credit_card_number: 4023948573948293, result: "success")
    @transaction_23 = @invoice_23.transactions.create!(credit_card_number: 4023948573948293, result: "success")
    @transaction_24 = @invoice_24.transactions.create!(credit_card_number: 4023948573948293, result: "success")
    @transaction_25 = @invoice_25.transactions.create!(credit_card_number: 4023948573948293, result: "success")
    @transaction_26 = @invoice_26.transactions.create!(credit_card_number: 4023948573948293, result: "success")
    @transaction_27 = @invoice_27.transactions.create!(credit_card_number: 4023948573948293, result: "success")
    @transaction_28 = @invoice_28.transactions.create!(credit_card_number: 4023948573948293, result: "success")

    visit admin_path

    within "#top_5" do
      expect("Debbie Twolegs").to appear_before("Brian Twinlegs")
      expect("Brian Twinlegs").to appear_before("Tommy Doubleleg")
      expect("Tommy Doubleleg").to appear_before("Jared Goffleg")
      expect("Jared Goffleg").to appear_before("Anten Branden")
      expect("Jared Goffleg").to_not appear_before("Debbie Twolegs")
      expect(page).to have_content("Debbie Twolegs - 7")
      expect(page).to have_content("Brian Twinlegs - 6")
      expect(page).to have_content("Tommy Doubleleg - 5")
      expect(page).to have_content("Jared Goffleg - 4")
      expect(page).to have_content("Anten Branden - 3")
      expect(page).to_not have_content("Pistol Pete - 2")
    end
  end
end
