class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items
  has_many :items, through: :invoice_items

  enum status: ['cancelled','in progress', 'completed']

  validates :status, inclusion: { in: statuses.keys }
end