class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :bulk_discounts, through: :invoice_items

  enum status: ['cancelled','in progress', 'completed']

  validates :status, inclusion: { in: statuses.keys }

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def self.incomplete_invoices_ordered
    Invoice.joins(:invoice_items).where(invoice_items: { status: [0, 1] }).order(:created_at).distinct
  end

  def merchant_object(id)
    Merchant.find(id)
  end

  def amount_off
    self.invoice_items.joins(:bulk_discounts)
                      .where('invoice_items.quantity >= threshold')
                      .select('invoice_items.*, percent_off')
                      .sum('((invoice_items.unit_price * quantity) * percent_off)')
  end

end
