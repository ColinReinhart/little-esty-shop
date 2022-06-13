require 'rails_helper'

RSpec.describe InvoiceItem do
  describe 'associations' do
    it { should belong_to :item}
    it { should belong_to :invoice}
    it {should have_many(:bulk_discounts).through(:item)}
  end

  describe 'validations' do
    it { should validate_presence_of :quantity}
    it { should validate_presence_of :unit_price}
    it { should define_enum_for(:status).with_values(['packaged', 'pending', 'shipped'])}
  end

  describe "Instance methods" do
      before :each do
        @merch_1 = Merchant.create!(name: "Two-Legs Fashion")
        @item_4 = @merch_1.items.create!(name: "Double Legged Pant", description: "pants built for people with two legs", unit_price: 10000)
        @cust_1 = Customer.create!(first_name: "Debbie", last_name: "Twolegs")
        @invoice_1 = @cust_1.invoices.create!(status: 1)
        @bulk_discount1 = @merch_1.bulk_discounts.create!(name: "20% Off", percent_off: 0.20, threshold: 10)
        @ii_1 = InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: @item_4.unit_price, status: 0)
        @ii_4 = InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice_1.id, quantity: 10, unit_price: @item_4.unit_price, status: 2)
        @bulk_discount2 = @merch_1.bulk_discounts.create!(name: "50% Off", percent_off: 0.50, threshold: 10)
      end

      it "#best_discount" do
        expect(@ii_1.best_discount).to eq(0)
        expect(@ii_4.best_discount).to eq(@bulk_discount2)
      end

      it "#qualify_for_discount" do
        expect(@ii_1.qualify_for_discount?).to eq(false)
        expect(@ii_4.qualify_for_discount?).to eq(true)
      end
  end
end
