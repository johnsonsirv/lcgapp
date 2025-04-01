class Event < ApplicationRecord
  has_many :participants

  enum :status, { open: 1, closed: 0 }

  validates :name, presence: true
  validates :theme, presence: true
  validates :year, presence: true, uniqueness: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 2025, less_than_or_equal_to: 2035 }
  validates :start_date, presence: true
  validates :end_date, presence: true

  scope :open_events, -> { where(status: :open) }

  default_scope -> { open_events }
end
