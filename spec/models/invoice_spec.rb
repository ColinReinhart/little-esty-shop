require 'rails_helper'

RSpec.describe Invoice do
  describe 'associations' do
    it { should belong_to :customer}
    it { should have_many :transactions}
    it { should have_many :invoice_items}
    it { should have_many(:items).through(:invoice_items)}
    it { should have_many(:bulk_discounts).through(:invoice_items)}
  end

  describe 'validations' do
    it { should define_enum_for(:status).with_values(['cancelled', 'in progress', 'completed'])}
  end

  describe 'class methods' do
    before :each do
      @merch_1 = Merchant.create!(name: "Two-Legs Fashion")

      @item_1 = @merch_1.items.create!(name: "Two-Leg Pantaloons", description: "pants built for people with two legs", unit_price: 5000)

      @cust_1 = Customer.create!(first_name: "Debbie", last_name: "Twolegs")
      @cust_2 = Customer.create!(first_name: "Tommy", last_name: "Doubleleg")

      @invoice_1 = @cust_1.invoices.create!(status: 1, created_at: "2022-06-03 17:51:52")
      @invoice_2 = @cust_1.invoices.create!(status: 1, created_at: "2022-05-25 17:51:52")
      @invoice_3 = @cust_1.invoices.create!(status: 1)
      @invoice_4 = @cust_2.invoices.create!(status: 1, created_at: "2022-05-03 17:51:52")
      @invoice_5 = @cust_2.invoices.create!(status: 1, created_at: "2022-05-08 17:51:52")
      @invoice_6 = @cust_2.invoices.create!(status: 1)

      @ii_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: @item_1.unit_price, status: 0)
      @ii_2 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_2.id, quantity: 1, unit_price: @item_1.unit_price, status: 1)
      @ii_3 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_3.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
      @ii_4 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_4.id, quantity: 1, unit_price: @item_1.unit_price, status: 0)
      @ii_5 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_5.id, quantity: 1, unit_price: @item_1.unit_price, status: 1)
      @ii_6 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_6.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
    end

    describe '#incomplete_invoices_ordered' do
      it 'returns incomplete invoices orderd from oldest to newest' do
        expect(Invoice.incomplete_invoices_ordered).to eq([@invoice_4, @invoice_5, @invoice_2, @invoice_1])
      end
    end

    it 'can access merchant object through item' do
      merch_1 = Merchant.create!(name: "Two-Legs Fashion")
      merch_2 = Merchant.create!(name: "Two-Legs Fashion")
      item_1 = merch_1.items.create!(name: "Two-Leg Pantaloons", description: "pants built for people with two legs", unit_price: 5086)
      item_2 = merch_1.items.create!(name: "Two-Leg Shorts", description: "shorts built for people with two legs", unit_price: 2999)
      item_3 = merch_2.items.create!(name: "Hat", description: "hat built for people with two legs and one head", unit_price: 6000)

      expect(item_1.merchant).to eq(merch_1)
      expect(item_2.merchant).to eq(merch_1)
      expect(item_3.merchant).to eq(merch_2)
    end
  end

  describe 'Instance methods' do
    it "can find amount to be deducted from total revenue" do
      @merch_1 = Merchant.create!(name: "Two-Legs Fashion")
      @item_4 = @merch_1.items.create!(name: "Double Legged Pant", description: "pants built for people with two legs", unit_price: 10000)
      @cust_1 = Customer.create!(first_name: "Debbie", last_name: "Twolegs")
      @invoice_1 = @cust_1.invoices.create!(status: 1)
      @bulk_discount1 = @merch_1.bulk_discounts.create!(name: "20% Off", percent_off: 0.20, threshold: 10)
      @ii_4 = InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice_1.id, quantity: 10, unit_price: @item_4.unit_price, status: 2)

      expect(@invoice_1.amount_off.to_i).to eq(20000)
    end
  end
end
