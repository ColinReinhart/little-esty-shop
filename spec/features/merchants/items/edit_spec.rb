require 'rails_helper'

RSpec.describe "merchant items edit page", type: :feature do
  before :each do
    @merchant_1 = Merchant.create(name: "Schroeder-Jerde" )
    @merchant_2 = Merchant.create(name: "Klein, Rempel and Jones")
    @item_1 = @merchant_1.items.create!(name: "Two-Leg Pantaloons", description: "pants built for people with two legs", unit_price: 5000)
    @item_2 = @merchant_2.items.create!(name: "Two-Leg Shorts", description: "shorts built for people with two legs", unit_price: 3000)

    visit edit_merchant_item_path(@merchant_1, @item_1)
  end
  it "shows edit form for item" do
    expect(page).to have_field("Name", with: 'Two-Leg Pantaloons')
    expect(page).to have_field("Description", with: 'pants built for people with two legs')
    expect(page).to have_field("Price in Cents", with: '5000')
    expect(page).to have_button("Submit")
  end

  it "can update item" do
    fill_in "Name", with: "One-Leg Pantaloons"
    fill_in "Description", with: "Very niche market"
    fill_in "unit_price", with: 1233
    click_button "Submit"
    expect(current_path).to eq(merchant_item_path(@merchant_1, @item_1))
    expect(page).to have_content("Item successfully updated!")
    expect(page).to have_content("One-Leg Pantaloons")
    expect(page).to have_content("Very niche market")
    expect(page).to_not have_content("Two-Leg Pantaloons")
    expect(page).to have_content("Price: $12.33")
  end

    it "can prevent item from being updated with incorrect information" do
    fill_in "Name", with: ""
    fill_in "Description", with: ""
    fill_in "unit_price", with: "asdasd"
    click_button "Submit"
    expect(current_path).to eq(edit_merchant_item_path(@merchant_1, @item_1))
    expect(page).to have_content("Error: Name can't be blank, Description can't be blank")
  end

end
