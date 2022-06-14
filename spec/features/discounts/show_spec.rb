require "rails_helper"

RSpec.describe "Discounts Show" do
  before :each do
    @merch_1 = Merchant.create(name: "Schroeder-Jerde" )
    @bulk_discount1 = BulkDiscount.create!(name: "%20 Off", percent_off: 0.2, threshold: 10, merchant_id: @merch_1.id)
  end

  it "shows the discount name, percentage, threshold and merchant" do
    visit merchant_bulk_discount_path(@merch_1, @bulk_discount1)

    expect(page).to have_content("Schroeder-Jerde")
    expect(page).to have_content("%20 Off")
    expect(page).to have_content("Get 20% off when you buy 10")
  end
end
