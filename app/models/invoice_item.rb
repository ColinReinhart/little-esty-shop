class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_many :bulk_discounts, through: :item

  validates_presence_of :quantity, :unit_price

  enum status: ['packaged', 'pending', 'shipped']

  validates :status, inclusion: { in: statuses.keys }

  def qualify_for_discount?
    best_discount != 0
  end

  def best_discount
    bulk_discounts.where('threshold <= ?', quantity).order(percent_off: :desc).first || 0
  end

end
