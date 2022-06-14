require 'rails_helper'

RSpec.describe 'merchant items new page' do
  before :each do
    @merch_1 = Merchant.create!(name: "Two-Legs Fashion")
    @merch_2 = Merchant.create!(name: "One-Legs Fashion")

    @item_1 = @merch_1.items.create!(name: "Two-Leg Pantaloons", description: "pants built for people with two legs", unit_price: 5000)
    @item_2 = @merch_1.items.create!(name: "Two-Leg Shorts", description: "shorts built for people with two legs", unit_price: 3000)
    @item_3 = @merch_1.items.create!(name: "Hat", description: "hat built for people with two legs and one head", unit_price: 6000)
    @item_4 = @merch_1.items.create!(name: "Double Legged Pant", description: "pants built for people with two legs", unit_price: 50000)
    @item_5 = @merch_1.items.create!(name: "Stainless Steel, 5-Pocket Jean", description: "Shorts of Steel", unit_price: 3000000)
    @item_6 = @merch_1.items.create!(name: "String of Numbers", description: "54921752964273", unit_price: 100)
    @item_6 = @merch_2.items.create!(name: "Pirate Pants", description: "Peg legs don't need pant legs", unit_price: 1000)

    visit new_merchant_item_path(@merch_1)
  end

  it 'can create a new merchant item' do
    fill_in "name", with: "Llamakini"
    fill_in "description", with: "Llama Swimsuit"
    click_button 'Save'
    expect(current_path).to eq("/merchants/#{@merch_1.id}/items/new")
    expect(page).to have_content("Error: Please fill out all required fields!")

    fill_in "name", with: "Llamakini"
    fill_in "description", with: "Llama Swimsuit"
    fill_in "unit_price", with: 420
    click_button 'Save'
    expect(current_path).to eq("/merchants/#{@merch_1.id}/items")
    expect(page).to have_content("Llamakini")
  end
end
