require 'rails_helper'

RSpec.describe 'merchant items index page' do
  before :each do
    @merch_1 = Merchant.create!(name: "Two-Legs Fashion")
    @merch_2 = Merchant.create!(name: "One-Legs Fashion")

    @item_1 = @merch_1.items.create!(name: "Two-Leg Pantaloons", description: "pants built for people with two legs", unit_price: 5000)
    @item_2 = @merch_1.items.create!(name: "Two-Leg Shorts", description: "shorts built for people with two legs", unit_price: 6000)
    @item_3 = @merch_1.items.create!(name: "Hat", description: "hat built for people with two legs and one head", unit_price: 7000)
    @item_4 = @merch_1.items.create!(name: "Double Legged Pant", description: "pants built for people with two legs", unit_price: 8000)
    @item_5 = @merch_1.items.create!(name: "Stainless Steel, 5-Pocket Jean", description: "Shorts of Steel", unit_price: 9000)
    @item_6 = @merch_1.items.create!(name: "String of Numbers", description: "54921752964273", unit_price: 10000)
    @item_7 = @merch_2.items.create!(name: "Pirate Pants", description: "Peg legs don't need pant legs", unit_price: 1000)

    @cust_1 = Customer.create!(first_name: "Debbie", last_name: "Twolegs")

    @invoice_1 = @cust_1.invoices.create!(status: 2)

    @ii_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: @item_1.unit_price, status: 0)
    @ii_2 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: @item_2.unit_price, status: 0)
    @ii_3 = InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: @item_3.unit_price, status: 0)
    @ii_4 = InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: @item_4.unit_price, status: 0)
    @ii_5 = InvoiceItem.create!(item_id: @item_5.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: @item_5.unit_price, status: 2)
    @ii_6 = InvoiceItem.create!(item_id: @item_6.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: @item_6.unit_price, status: 2)

    @trans_1 = @invoice_1.transactions.create!(credit_card_number: '4444555566667777', result: 'success')

    visit merchant_items_path(@merch_1)
  end

  it 'displays a list of the names of all the merchants items and none from any other merchant' do
    expect(page).to have_content("Two-Leg Pantaloons")
    expect(page).to have_content("Two-Leg Shorts")
    expect(page).to have_content("Hat")
    expect(page).to have_content("Double Legged Pant")
    expect(page).to have_content("Stainless Steel, 5-Pocket Jean")
    expect(page).to have_content("String of Numbers")
    expect(page).to_not have_content("Pirate Pants")
  end

  it 'can disable/enable an item and the items are separated and displayed by status' do
    within "#disabled" do
      within "#item-#{@item_1.id}" do
        expect(page).to_not have_button("Disable")
        click_button("Enable")
        expect(current_path).to eq("/merchants/#{@merch_1.id}/items")
      end
    end
    within "#enabled" do
      within "#item-#{@item_1.id}" do
        expect(page).to_not have_button("Enable")
        click_button("Disable")
        expect(current_path).to eq("/merchants/#{@merch_1.id}/items")
      end
    end
  end

  it 'has a link to create a new item' do
    click_link("New Item")
    expect(current_path).to eq("/merchants/#{@merch_1.id}/items/new")

  end

  it "lists the 5 most popular items by revenue" do
    within "#top_5_items" do
      expect(@item_6.name).to appear_before(@item_5.name)
      expect(@item_5.name).to appear_before(@item_4.name)
      expect(@item_4.name).to appear_before(@item_3.name)
      expect(page).to_not have_content(@item_1.name)

      expect(page).to have_content("Total Revenue: $100.00")
      expect(page).to have_content("Total Revenue: $90.00")
      expect(page).to have_content("Total Revenue: $80.00")
      expect(page).to have_content("Total Revenue: $70.00")
      expect(page).to have_content("Total Revenue: $60.00")
    end
  end

  it "adds the date to the top 5 most popular items" do
    merch1 = Merchant.create!(name: 'Merch1')
    merch2 = Merchant.create!(name: 'Merch2')

    item1 = merch1.items.create!(name: 'item1', description: 'test item1', unit_price: 100)
    item2 = merch1.items.create!(name: 'item2', description: 'test item2', unit_price: 100)
    item3 = merch1.items.create!(name: 'item3', description: 'test item3', unit_price: 100)
    item4 = merch1.items.create!(name: 'item4', description: 'test item4', unit_price: 100)
    item5 = merch1.items.create!(name: 'item5', description: 'test item5', unit_price: 100)
    item6 = merch1.items.create!(name: 'item6', description: 'test item6', unit_price: 100)

    item7 = merch2.items.create!(name: 'item7', description: 'test item7', unit_price: 100)
    item8 = merch2.items.create!(name: 'item8', description: 'test item8', unit_price: 100)
    item9 = merch2.items.create!(name: 'item9', description: 'test item9', unit_price: 100)
    item10 = merch2.items.create!(name: 'item10', description: 'test item10', unit_price: 100)
    item11 = merch2.items.create!(name: 'item11', description: 'test item11', unit_price: 100)
    item12 = merch2.items.create!(name: 'item12', description: 'test item12', unit_price: 100)

    cust1 = Customer.create!(first_name: 'Cory', last_name: 'Bethune')
    cust2 = Customer.create!(first_name: 'Billy', last_name: 'Bob')

    invoice1 = cust1.invoices.create!(status: 2)
    invoice2 = cust2.invoices.create!(status: 2)

    trans1 = invoice1.transactions.create!(credit_card_number: '0000111122223333', result: 'success')
    trans2 = invoice2.transactions.create!(credit_card_number: '4444555566667777', result: 'success')

    ii1 = InvoiceItem.create!(quantity: 10, unit_price: 100, status: 2, item_id: item1.id, invoice_id: invoice1.id)
    ii2 = InvoiceItem.create!(quantity: 2, unit_price: 100, status: 2, item_id: item2.id, invoice_id: invoice1.id)
    ii3 = InvoiceItem.create!(quantity: 5, unit_price: 100, status: 2, item_id: item3.id, invoice_id: invoice1.id)
    ii4 = InvoiceItem.create!(quantity: 20, unit_price: 100, status: 2, item_id: item4.id, invoice_id: invoice1.id)
    ii5 = InvoiceItem.create!(quantity: 100, unit_price: 100, status: 2, item_id: item5.id, invoice_id: invoice1.id)
    ii6 = InvoiceItem.create!(quantity: 1, unit_price: 100, status: 2, item_id: item6.id, invoice_id: invoice1.id)

    ii7 = InvoiceItem.create!(quantity: 1, unit_price: 100, status: 2, item_id: item7.id, invoice_id: invoice2.id)
    ii8 = InvoiceItem.create!(quantity: 12, unit_price: 100, status: 2, item_id: item8.id, invoice_id: invoice2.id)
    ii9 = InvoiceItem.create!(quantity: 13, unit_price: 100, status: 2, item_id: item9.id, invoice_id: invoice2.id)
    ii10 = InvoiceItem.create!(quantity: 100, unit_price: 100, status: 2, item_id: item10.id, invoice_id: invoice2.id)
    ii11 = InvoiceItem.create!(quantity: 5, unit_price: 100, status: 2, item_id: item11.id, invoice_id: invoice2.id)
    ii12 = InvoiceItem.create!(quantity: 0, unit_price: 100, status: 2, item_id: item12.id, invoice_id: invoice2.id)

    visit merchant_items_path(merch1)

    within "#top_5_items" do
      expect(page).to have_content("Top selling date for #{item5.name} was #{item5.invoices.first.created_at.strftime('%B %d, %Y')}")
      expect(page).to have_content("Top selling date for #{item4.name} was #{item4.invoices.first.created_at.strftime('%B %d, %Y')}")
      expect(page).to have_content("Top selling date for #{item1.name} was #{item1.invoices.first.created_at.strftime('%B %d, %Y')}")
      expect(page).to have_content("Top selling date for #{item3.name} was #{item3.invoices.first.created_at.strftime('%B %d, %Y')}")
      expect(page).to have_content("Top selling date for #{item2.name} was #{item2.invoices.first.created_at.strftime('%B %d, %Y')}")
      expect(item5.name).to appear_before(item4.name)
      expect(item4.name).to appear_before(item1.name)
      expect(item1.name).to appear_before(item3.name)
      expect(item3.name).to appear_before(item2.name)

      expect(page).to_not have_content(item7.name)
      expect(page).to_not have_content(item10.name)
      expect(page).to_not have_content(item9.name)
    end
  end
end
