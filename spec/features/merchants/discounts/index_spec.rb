require "rails_helper"

RSpec.describe "Discounts Index" do
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
  it "shows the discount name, percentage, threshold and merchant"do
    visit "/merchants/#{@merch_1.id}/bulk_discounts"

    expect(page).to have_link("%20 Off")
    expect(page).to have_content("Get 20% off when you buy 10")
    click_link "%20 Off"
    expect(current_path).to eq("/merchants/#{@merch_1.id}/bulk_discounts/#{@bulk_discount1.id}")
  end

  it "has link to create new discount" do
    visit "/merchants/#{@merch_1.id}/bulk_discounts"

    expect(page).to have_link("Create New Bulk Discount")
    click_link "Create New Bulk Discount"
    expect(current_path).to eq(new_merchant_bulk_discount_path(@merch_1))
  end

  it "can delete a discount" do
    visit "/merchants/#{@merch_1.id}/bulk_discounts"

    within "##{@bulk_discount1.id}" do
      expect(page).to have_link("Delete Discount")
      click_link "Delete Discount"
    end
    expect(page).to_not have_content("%20 Off")
    expect(page).to_not have_content("Get 20% off when you buy 10")
  end

  it "shows next three holidays" do
    visit "/merchants/#{@merch_1.id}/bulk_discounts"

    expect(page).to have_content("Juneteenth")
    expect(page).to have_content("Independence Day")
    expect(page).to have_content("Labour Day")
    expect(page).to_not have_content("Columbus day")
  end
end
