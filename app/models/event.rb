class Event < ApplicationRecord
  has_many :participants

  validates :name, presence: true
  validates :theme, presence: true
  validates :year, presence: true, uniqueness: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :location, presence: true
  validates :registration_status, inclusion: { in: %w[open closed] }
end
