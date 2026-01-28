class Souvenir < ApplicationRecord
  belongs_to :user

  enum :category, {
    food: 0,
    goods: 1,
    cosmetic: 2,
    craft: 3,
    other: 4
  }

  validates :name, presence: true, length: { maximum: 100 }
  validates :price, presence: true,
            numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 1_000_000 }
  validates :category, presence: true

  scope :within_budget, ->(budget) { where('price <= ?', budget) }
  scope :by_category, ->(category) { where(category: category) if category.present? }
end
