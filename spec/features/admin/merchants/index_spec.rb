require 'rails_helper'

RSpec.describe 'admin merchants index', type: :feature do
      before :each do
        @merch_1 = Merchant.create!(name: "Two-Legs Fashion")
        @merch_2 = Merchant.create(name: "Klein, Rempel and Jones")
        @merch_3 = Merchant.create!(name: "Peg-Leg Fashion")
        @merch_4 = Merchant.create!(name: "Buck-an-Ear Jewelry")
        @merch_5 = Merchant.create!(name: "Orange You Glad")
        @merch_6 = Merchant.create!(name: "Absolutely Authentic Autographs")

        @item_1 = @merch_1.items.create!(name: "Two-Leg Pantaloons", description: "pants built for people with two legs", unit_price: 5000)
        @item_2 = @merch_2.items.create!(name: "Two-Leg Shorts", description: "shorts built for people with two legs", unit_price: 3000)
        @item_3 = @merch_3.items.create!(name: "Hat", description: "hat built for people with two legs and one head", unit_price: 6000)
        @item_4 = @merch_4.items.create!(name: "Double Legged Pant", description: "pants built for people with two legs", unit_price: 50000)
        @item_5 = @merch_5.items.create!(name: "Stainless Steel, 5-Pocket Jean", description: "Shorts of Steel", unit_price: 3000000)
        @item_6 = @merch_6.items.create!(name: "String of Numbers", description: "54921752964273", unit_price: 100)
        @item_7 = @merch_6.items.create!(name: "Shirt", description: "shirt for people", unit_price: 50000)

        @cust_1 = Customer.create!(first_name: "Debbie", last_name: "Twolegs")
        @cust_2 = Customer.create!(first_name: "Tommy", last_name: "Doubleleg")
        @cust_3 = Customer.create!(first_name: "Brian", last_name: "Twinlegs")
        @cust_4 = Customer.create!(first_name: "Jared", last_name: "Goffleg")
        @cust_5 = Customer.create!(first_name: "Pistol", last_name: "Pete")
        @cust_6 = Customer.create!(first_name: "Bronson", last_name: "Shmonson")
        @cust_7 = Customer.create!(first_name: "Anten", last_name: "Branden")
        @cust_8 = Customer.create!(first_name: "Anthony", last_name: "Smith")

        @invoice_1 = @cust_1.invoices.create!(status: 1, created_at: "2022-05-03 17:51:52")
        @invoice_2 = @cust_1.invoices.create!(status: 1, created_at: "2022-05-03 17:51:52")
        @invoice_3 = @cust_1.invoices.create!(status: 1, created_at: "2022-05-03 17:51:52")
        @invoice_4 = @cust_2.invoices.create!(status: 1, created_at: "2022-05-13 17:51:52")
        @invoice_5 = @cust_2.invoices.create!(status: 1, created_at: "2022-05-13 17:51:52")
        @invoice_6 = @cust_2.invoices.create!(status: 1, created_at: "2022-05-13 17:51:52")
        @invoice_7 = @cust_2.invoices.create!(status: 1, created_at: "2022-05-13 17:51:52")
        @invoice_8 = @cust_3.invoices.create!(status: 1, created_at: "2022-05-20 17:51:52")
        @invoice_9 = @cust_3.invoices.create!(status: 1, created_at: "2022-05-20 17:51:52")
        @invoice_10 = @cust_5.invoices.create!(status: 1, created_at: "2022-05-20 17:51:52")
        @invoice_11 = @cust_6.invoices.create!(status: 1, created_at: "2022-05-20 17:51:52")
        @invoice_12 = @cust_6.invoices.create!(status: 1, created_at: "2022-05-20 17:51:52")
        @invoice_13 = @cust_6.invoices.create!(status: 1, created_at: "2022-05-20 17:51:52")
        @invoice_14 = @cust_7.invoices.create!(status: 1, created_at: "2022-05-01 17:51:52")
        @invoice_15 = @cust_7.invoices.create!(status: 2, created_at: "2022-05-30 17:51:52")
        @invoice_16 = @cust_7.invoices.create!(status: 2, created_at: "2022-06-03 17:51:52")
        @invoice_17 = @cust_8.invoices.create!(status: 1, created_at: "2022-05-03 17:51:52")
        @invoice_18 = @cust_8.invoices.create!(status: 1, created_at: "2022-05-21 17:51:52")
        @invoice_19 = @cust_8.invoices.create!(status: 1, created_at: "2022-05-03 17:51:52")

        @ii_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
        @ii_2 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_2.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
        @ii_3 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_3.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
        @ii_4 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_4.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
        @ii_5 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_5.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
        @ii_6 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_6.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
        @ii_7 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_7.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
        @ii_8 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_8.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
        @ii_9 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_9.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
        @ii_10 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_10.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)

        @ii_11 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_11.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
        @ii_12 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_12.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
        @ii_13 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_13.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
        @ii_14 = InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice_19.id, quantity: 500, unit_price: @item_4.unit_price, status: 2)
        @ii_15 = InvoiceItem.create!(item_id: @item_6.id, invoice_id: @invoice_14.id, quantity: 1, unit_price: @item_6.unit_price, status: 2)
        @ii_16 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_14.id, quantity: 30, unit_price: @item_1.unit_price, status: 2)
        @ii_17 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_14.id, quantity: 30, unit_price: @item_2.unit_price, status: 2)
        @ii_18 = InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_18.id, quantity: 30, unit_price: @item_3.unit_price, status: 2)
        @ii_19 = InvoiceItem.create!(item_id: @item_5.id, invoice_id: @invoice_15.id, quantity: 700, unit_price: @item_5.unit_price, status: 2)
        @ii_20 = InvoiceItem.create!(item_id: @item_7.id, invoice_id: @invoice_16.id, quantity: 700, unit_price: @item_7.unit_price, status: 2)
        @ii_21 = InvoiceItem.create!(item_id: @item_7.id, invoice_id: @invoice_17.id, quantity: 300, unit_price: @item_7.unit_price, status: 2)

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
        @transaction_14 = @invoice_14.transactions.create!(credit_card_number: 4023948573948293, result: "failure")
        @transaction_15 = @invoice_15.transactions.create!(credit_card_number: 4023948573948293, result: "success")
        @transaction_16 = @invoice_16.transactions.create!(credit_card_number: 4023948573948394, result: "success")
        @transaction_17 = @invoice_17.transactions.create!(credit_card_number: 4023948573948394, result: "success")
        @transaction_18 = @invoice_18.transactions.create!(credit_card_number: 4023948573948394, result: "success")
        @transaction_19 = @invoice_19.transactions.create!(credit_card_number: 4023948573948394, result: "success")
  end

  it "displays all merchants" do
    visit merchants_path

    expect(page).to have_content(@merch_1.name)
    expect(page).to have_content(@merch_2.name)
    expect(page).to have_content(@merch_3.name)
    expect(page).to have_content(@merch_4.name)
  end

  it "links to merchants show page from merchants name" do
    visit merchants_path
    within "#disabled" do
        click_link "Orange You Glad"
    end
    expect(current_path).to eq("/admin/merchants/#{@merch_5.id}")
  end

  it 'has buttons next to each merchant that can enable/disable' do
    visit merchants_path
    within "#disabled" do
        within "#merchant-#{@merch_1.id}" do
            expect(page).to_not have_button("Disable")
            click_button("Enable")
            expect(current_path).to eq(merchants_path)
        end

        within "#merchant-#{@merch_4.id}" do
            expect(page).to_not have_button("Disable")
            click_button("Enable")
            expect(current_path).to eq(merchants_path)
        end
    end

    within "#enabled" do
        within "#merchant-#{@merch_1.id}" do
            expect(page).to_not have_button("Enable")
            click_button("Disable")
            expect(current_path).to eq(merchants_path)
        end

        within "#merchant-#{@merch_4.id}" do
            expect(page).to_not have_button("Enable")
            click_button("Disable")
            expect(current_path).to eq(merchants_path)
        end
    end
  end

  it 'shows top 5 merchants by revenue' do
    visit merchants_path
    within "#top_5" do
        within "#merchant-0" do
            expect(page).to have_content("Orange You Glad")
            expect(page).to have_content("$21,000,000 in sales")
            expect(page).to_not have_content(@merch_1.name)
        end
        within "#merchant-4" do
            expect(page).to have_content("Two-Legs Fashion")
            expect(page).to have_content("$650 in sales")
            expect(page).to_not have_content(@merch_4.name)
        end
    end
  end

  it 'displays the top selling date for each of the top 5 merchants' do
    visit merchants_path

    within "#top_5" do
      within "#merchant-0" do
        expect(page).to have_content("Top day for Orange You Glad's store was 05/30/22")
        expect(page).to_not have_content("Top day for Absolutely Authentic Autographs's store was 06/03/22")
        expect(page).to_not have_content("Top day for Buck-an-Ear Jewelry's store was 05/03/22")
        expect(page).to_not have_content("Top day for Peg-Leg Fashion's store was 05/21/22")
        expect(page).to_not have_content("Top day for Two-Legs Fashion's store was 05/01/22")
      end
      within "#merchant-1" do
        expect(page).to have_content("Top day for Absolutely Authentic Autographs's store was 06/03/22")
        expect(page).to_not have_content("Top day for Orange You Glad's store was 05/30/22")
        expect(page).to_not have_content("Top day for Buck-an-Ear Jewelry's store was 05/03/22")
        expect(page).to_not have_content("Top day for Peg-Leg Fashion's store was 05/21/22")
        expect(page).to_not have_content("Top day for Two-Legs Fashion's store was 05/01/22")
      end
      within "#merchant-2" do
        expect(page).to have_content("Top day for Buck-an-Ear Jewelry's store was 05/03/22")
        expect(page).to_not have_content("Top day for Orange You Glad's store was 05/30/22")
        expect(page).to_not have_content("Top day for Absolutely Authentic Autographs's store was 06/03/22")
        expect(page).to_not have_content("Top day for Peg-Leg Fashion's store was 05/21/22")
        expect(page).to_not have_content("Top day for Two-Legs Fashion's store was 05/01/22")
      end
      within "#merchant-3" do
        expect(page).to have_content("Top day for Peg-Leg Fashion's store was 05/21/22")
        expect(page).to_not have_content("Top day for Orange You Glad's store was 05/30/22")
        expect(page).to_not have_content("Top day for Absolutely Authentic Autographs's store was 06/03/22")
        expect(page).to_not have_content("Top day for Buck-an-Ear Jewelry's store was 05/03/22")
        expect(page).to_not have_content("Top day for Two-Legs Fashion's store was 05/01/22")
      end
      within "#merchant-4" do
        expect(page).to have_content("Top day for Two-Legs Fashion's store was 05/01/22")
        expect(page).to_not have_content("Top day for Orange You Glad's store was 05/30/22")
        expect(page).to_not have_content("Top day for Absolutely Authentic Autographs's store was 06/03/22")
        expect(page).to_not have_content("Top day for Buck-an-Ear Jewelry's store was 05/03/22")
        expect(page).to_not have_content("Top day for Peg-Leg Fashion's store was 05/21/22")
      end
    end
  end
end
