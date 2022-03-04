class Order < ApplicationRecord
  belongs_to :user

  has_many :placements, dependent: :destroy
  has_many :products, through: :placements

  before_validation :set_total!

  validates :total, numericality: { greater_than_or_equal_to: 0 }
  validates :total, presence: true

  # Стоимость заказа формируется динамически, по товарам содержащимся в заказе
  def set_total!
    self.total = products.map(&:price).sum
  end
end
