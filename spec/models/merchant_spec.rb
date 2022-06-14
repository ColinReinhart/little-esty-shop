require 'rails_helper'

RSpec.describe Merchant do

  describe 'associations' do
    it { should have_many :items}
    it { should have_many :bulk_discounts}
    it { should have_many(:invoice_items).through(:items)}
    it { should have_many(:invoices).through(:invoice_items)}
    it { should have_many(:customers).through(:invoices)}
    it { should have_many(:transactions).through(:invoices)}

  end

  describe 'validations' do
    it { should validate_presence_of :name}
    it { should validate_presence_of :status}
  end

  describe 'instance methods' do

    describe '#items_ready_to_ship' do

      before :each do
        @merch_1 = Merchant.create!(name: "Two-Legs Fashion")
        @merch_2 = Merchant.create!(name: "Klein, Rempel and Jones")

        @item_1 = @merch_1.items.create!(name: "Two-Leg Pantaloons", description: "pants built for people with two legs", unit_price: 5000)
        @item_2 = @merch_1.items.create!(name: "Two-Leg Shorts", description: "shorts built for people with two legs", unit_price: 3000)
        @item_3 = @merch_1.items.create!(name: "Hat", description: "hat built for people with two legs and one head", unit_price: 6000)
        @item_4 = @merch_2.items.create!(name: "Pant", description: "pants built for people", unit_price: 50000)

        @cust_1 = Customer.create!(first_name: "Debbie", last_name: "Twolegs")
        @cust_2 = Customer.create!(first_name: "Tommy", last_name: "Doubleleg")

        @invoice_1 = @cust_1.invoices.create!(status: 1)
        @invoice_2 = @cust_1.invoices.create!(status: 1)
        @invoice_3 = @cust_1.invoices.create!(status: 1)
        @invoice_4 = @cust_2.invoices.create!(status: 1)
        @invoice_5 = @cust_2.invoices.create!(status: 1)
        @invoice_6 = @cust_2.invoices.create!(status: 1)

        @ii_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: @item_1.unit_price, status: 0)
        @ii_2 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_2.id, quantity: 1, unit_price: @item_1.unit_price, status: 1)
        @ii_3 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_2.id, quantity: 1, unit_price: @item_2.unit_price, status: 2)
        @ii_4 = InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_2.id, quantity: 1, unit_price: @item_3.unit_price, status: 2)
        @ii_5 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_4.id, quantity: 1, unit_price: @item_1.unit_price, status: 1)
        @ii_6 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_4.id, quantity: 1, unit_price: @item_2.unit_price, status: 1)
        @ii_7 = InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice_6.id, quantity: 1, unit_price: @item_4.unit_price, status: 1)
      end

      it 'returns the items that have not yet been shipped for a particular merchant' do
        expect(@merch_1.items_ready_to_ship).to eq([@ii_1, @ii_2, @ii_5, @ii_6])
        expect(@merch_2.items_ready_to_ship).to eq([@ii_7])
      end
    end

    describe '#top_5_customers' do

      before :each do
        @merch_1 = Merchant.create!(name: "Two-Legs Fashion")
        @merch_2 = Merchant.create(name: "Klein, Rempel and Jones")

        @item_1 = @merch_1.items.create!(name: "Two-Leg Pantaloons", description: "pants built for people with two legs", unit_price: 5000)
        @item_2 = @merch_1.items.create!(name: "Two-Leg Shorts", description: "shorts built for people with two legs", unit_price: 3000)
        @item_3 = @merch_1.items.create!(name: "Hat", description: "hat built for people with two legs and one head", unit_price: 6000)
        @item_4 = @merch_1.items.create!(name: "Double Legged Pant", description: "pants built for people with two legs", unit_price: 50000)
        @item_5 = @merch_1.items.create!(name: "Stainless Steel, 5-Pocket Jean", description: "Shorts of Steel", unit_price: 3000000)
        @item_6 = @merch_1.items.create!(name: "String of Numbers", description: "54921752964273", unit_price: 100)
        @item_7 = @merch_2.items.create!(name: "Shirt", description: "shirt for people", unit_price: 50000)

        @cust_1 = Customer.create!(first_name: "Debbie", last_name: "Twolegs")
        @cust_2 = Customer.create!(first_name: "Tommy", last_name: "Doubleleg")
        @cust_3 = Customer.create!(first_name: "Brian", last_name: "Twinlegs")
        @cust_4 = Customer.create!(first_name: "Jared", last_name: "Goffleg")
        @cust_5 = Customer.create!(first_name: "Pistol", last_name: "Pete")
        @cust_6 = Customer.create!(first_name: "Bronson", last_name: "Shmonson")
        @cust_7 = Customer.create!(first_name: "Anten", last_name: "Branden")
        @cust_8 = Customer.create!(first_name: "Anthony", last_name: "Smith")

        @invoice_1 = @cust_1.invoices.create!(status: 1)
        @invoice_2 = @cust_1.invoices.create!(status: 1)
        @invoice_3 = @cust_1.invoices.create!(status: 1)
        @invoice_4 = @cust_2.invoices.create!(status: 1)
        @invoice_5 = @cust_2.invoices.create!(status: 1)
        @invoice_6 = @cust_2.invoices.create!(status: 1)
        @invoice_7 = @cust_2.invoices.create!(status: 1)
        @invoice_8 = @cust_3.invoices.create!(status: 1)
        @invoice_9 = @cust_3.invoices.create!(status: 1)
        @invoice_10 = @cust_5.invoices.create!(status: 1)
        @invoice_11 = @cust_6.invoices.create!(status: 1)
        @invoice_12 = @cust_6.invoices.create!(status: 1)
        @invoice_13 = @cust_6.invoices.create!(status: 1)
        @invoice_14 = @cust_7.invoices.create!(status: 1)
        @invoice_15 = @cust_7.invoices.create!(status: 2)
        @invoice_16 = @cust_8.invoices.create!(status: 1)

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
        @ii_14 = InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice_14.id, quantity: 500, unit_price: @item_4.unit_price, status: 2)
        @ii_15 = InvoiceItem.create!(item_id: @item_6.id, invoice_id: @invoice_14.id, quantity: 1, unit_price: @item_4.unit_price, status: 2)
        @ii_16 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_14.id, quantity: 30, unit_price: @item_1.unit_price, status: 2)
        @ii_17 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_14.id, quantity: 30, unit_price: @item_2.unit_price, status: 2)
        @ii_18 = InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_14.id, quantity: 30, unit_price: @item_3.unit_price, status: 2)
        @ii_19 = InvoiceItem.create!(item_id: @item_5.id, invoice_id: @invoice_15.id, quantity: 700, unit_price: @item_5.unit_price, status: 2)
        @ii_20 = InvoiceItem.create!(item_id: @item_7.id, invoice_id: @invoice_16.id, quantity: 300, unit_price: @item_7.unit_price, status: 2)

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
      end

      it 'returns the top 5 customers with the merchant' do
        expect(@merch_1.top_5_customers).to eq([@cust_2, @cust_1, @cust_6, @cust_3, @cust_5])
        expect(@merch_2.top_5_customers).to eq([@cust_8])
      end
    end

    describe 'best_day' do

      before :each do
        @merch_1 = Merchant.create!(name: "Two-Legs Fashion")
        @merch_2 = Merchant.create(name: "Klein, Rempel and Jones")

        @item_1 = @merch_1.items.create!(name: "Two-Leg Pantaloons", description: "pants built for people with two legs", unit_price: 5000)
        @item_2 = @merch_2.items.create!(name: "Two-Leg Shorts", description: "shorts built for people with two legs", unit_price: 3000)

        @cust_1 = Customer.create!(first_name: "Debbie", last_name: "Twolegs")
        @cust_2 = Customer.create!(first_name: "Tommy", last_name: "Doubleleg")
        @cust_3 = Customer.create!(first_name: "Brian", last_name: "Twinlegs")

        @invoice_1 = @cust_1.invoices.create!(status: 1, created_at: "2022-05-03 17:51:52")
        @invoice_2 = @cust_1.invoices.create!(status: 1, created_at: "2022-05-13 17:52:52")
        @invoice_3 = @cust_1.invoices.create!(status: 1, created_at: "2022-05-13 17:53:52")
        @invoice_4 = @cust_2.invoices.create!(status: 1, created_at: "2022-05-13 17:54:52")
        @invoice_5 = @cust_2.invoices.create!(status: 1, created_at: "2022-05-23 17:55:52")
        @invoice_6 = @cust_2.invoices.create!(status: 1, created_at: "2022-05-23 17:56:52")
        @invoice_7 = @cust_3.invoices.create!(status: 1, created_at: "2022-05-23 17:57:52")
        @invoice_8 = @cust_3.invoices.create!(status: 1, created_at: "2022-05-23 17:58:52")
        @invoice_9 = @cust_3.invoices.create!(status: 1, created_at: "2022-05-23 17:59:52")
        @invoice_10 = @cust_3.invoices.create!(status: 1, created_at: "2022-05-30 17:51:53")
        @invoice_11 = @cust_3.invoices.create!(status: 1, created_at: "2022-05-30 17:51:54")
        @invoice_12 = @cust_3.invoices.create!(status: 1, created_at: "2022-05-30 17:51:55")

        InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 4, unit_price: @item_1.unit_price, status: 2)
        InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_2.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
        InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_3.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
        InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_4.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
        InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_5.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
        InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_6.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
        InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_7.id, quantity: 2, unit_price: @item_2.unit_price, status: 2)
        InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_8.id, quantity: 2, unit_price: @item_2.unit_price, status: 2)
        InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_9.id, quantity: 2, unit_price: @item_2.unit_price, status: 2)
        InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_10.id, quantity: 2, unit_price: @item_2.unit_price, status: 2)
        InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_11.id, quantity: 2, unit_price: @item_2.unit_price, status: 2)
        InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_12.id, quantity: 2, unit_price: @item_2.unit_price, status: 2)
      end

      it 'returns the date with the most revenue for the merchant' do
        expect(@merch_1.best_day.strftime("%A, %B %d, %Y")).to eq("Tuesday, May 03, 2022")
        expect(@merch_2.best_day.strftime("%A, %B %d, %Y")).to eq("Monday, May 30, 2022")
      end
    end
  end

  describe 'class methods' do

    describe '#top_5_merchants' do

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

        @invoice_1 = @cust_1.invoices.create!(status: 1)
        @invoice_2 = @cust_1.invoices.create!(status: 1)
        @invoice_3 = @cust_1.invoices.create!(status: 1)
        @invoice_4 = @cust_2.invoices.create!(status: 1)
        @invoice_5 = @cust_2.invoices.create!(status: 1)
        @invoice_6 = @cust_2.invoices.create!(status: 1)
        @invoice_7 = @cust_2.invoices.create!(status: 1)
        @invoice_8 = @cust_3.invoices.create!(status: 1)
        @invoice_9 = @cust_3.invoices.create!(status: 1)
        @invoice_10 = @cust_5.invoices.create!(status: 1)
        @invoice_11 = @cust_6.invoices.create!(status: 1)
        @invoice_12 = @cust_6.invoices.create!(status: 1)
        @invoice_13 = @cust_6.invoices.create!(status: 1)
        @invoice_14 = @cust_7.invoices.create!(status: 1)
        @invoice_15 = @cust_7.invoices.create!(status: 2)
        @invoice_16 = @cust_7.invoices.create!(status: 2)
        @invoice_17 = @cust_8.invoices.create!(status: 1)
        @invoice_18 = @cust_8.invoices.create!(status: 1)
        @invoice_19 = @cust_8.invoices.create!(status: 1)

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

      it 'returns the top 5 merchants by revenue' do
        expect(Merchant.top_5_merchants_by_revenue.to_a).to eq([@merch_5, @merch_6, @merch_4, @merch_3, @merch_1])
      end
      describe "#top_5_items" do
        before :each do
          @merch_1 = Merchant.create!(name: "Two-Legs Fashion")
          @item_1 = @merch_1.items.create!(name: "Two-Leg Pantaloons", description: "pants built for people with two legs", unit_price: 5000)
          @item_2 = @merch_1.items.create!(name: "Two-Leg Shorts", description: "shorts built for people with two legs", unit_price: 3000)
          @item_3 = @merch_1.items.create!(name: "Hat", description: "hat built for people with two legs and one head", unit_price: 6000)
          @item_4 = @merch_1.items.create!(name: "Double Legged Pant", description: "pants built for people with two legs", unit_price: 50000)
          @item_5 = @merch_1.items.create!(name: "Stainless Steel, 5-Pocket Jean", description: "Shorts of Steel", unit_price: 3000000)
          @item_6 = @merch_1.items.create!(name: "String of Numbers", description: "54921752964273", unit_price: 100)
          @invoice_1 = @cust_1.invoices.create!(status: 2)
          @invoice_2 = @cust_1.invoices.create!(status: 2)
          @invoice_3 = @cust_1.invoices.create!(status: 2)
          @invoice_4 = @cust_1.invoices.create!(status: 2)
          @invoice_5 = @cust_1.invoices.create!(status: 2)
          @invoice_6 = @cust_1.invoices.create!(status: 2)
          @ii_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 6, unit_price: @item_1.unit_price, status: 2)
          @ii_2 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_2.id, quantity: 5, unit_price: @item_1.unit_price, status: 2)
          @ii_3 = InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_3.id, quantity: 4, unit_price: @item_1.unit_price, status: 2)
          @ii_4 = InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice_4.id, quantity: 3, unit_price: @item_1.unit_price, status: 2)
          @ii_5 = InvoiceItem.create!(item_id: @item_5.id, invoice_id: @invoice_5.id, quantity: 2, unit_price: @item_1.unit_price, status: 2)
          @ii_6 = InvoiceItem.create!(item_id: @item_6.id, invoice_id: @invoice_6.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
        end
        it "returns the top 5 items" do
          expect(@merch_1.top_5_items).to eq([@item_1, @item_2, @item_3, @item_4, @item_5])
        end
      end
    end
  end

end
