require "rails_helper"

RSpec.describe "Edit Discount page" do
  before :each do
    @merch_1 = Merchant.create(name: "Schroeder-Jerde" )
    @bulk_discount1 = BulkDiscount.create!(name: "%20 Off", percent_off: 0.2, threshold: 10, merchant_id: @merch_1.id)

    visit merchant_bulk_discount_path(@merch_1, @bulk_discount1)
  end
  it "can edit discount" do
    expect(page).to have_link("Edit Discount")
    click_link "Edit Discount"
    expect(current_path).to eq("/merchants/#{@merch_1.id}/bulk_discounts/#{@bulk_discount1.id}/edit")

    fill_in :name, with: "New Name"
    fill_in :percent_off, with: ""
    click_on "Submit"
    expect(current_path).to eq("/merchants/#{@merch_1.id}/bulk_discounts/#{@bulk_discount1.id}/edit")

    fill_in :name, with: "New Name"
    fill_in :percent_off, with: ".5"
    fill_in :threshold, with: 200
    click_on "Submit"

    expect(current_path).to eq("/merchants/#{@merch_1.id}/bulk_discounts/#{@bulk_discount1.id}")

    expect(page).to have_content("New Name")
    expect(page).to have_content("Get 50% off when you buy 200")
  end
end
