require "rails_helper"

RSpec.describe "New Discount" do
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

    @bulk_discount1 = BulkDiscount.create!(name: "%20 Off", percent_off: 0.2, threshold: 10, merchant_id: @merch_1.id)
  end

  it "can create a new discount" do
    visit new_merchant_bulk_discount_path(@merch_1)

    fill_in :name, with: "5% Off"
    click_on "Submit"
    expect(page).to have_content("Please fill out entire form before submitting")
    expect(current_path).to eq(new_merchant_bulk_discount_path(@merch_1))

    fill_in :name, with: "5% Off"
    fill_in :percent_off, with: 0.05
    fill_in :threshold, with: 5
    click_on "Submit"
    expect(current_path).to eq(merchant_bulk_discounts_path(@merch_1))
    expect(page).to have_content("5% Off")
    expect(page).to have_content("Get 5% off when you buy 5")
  end
end
