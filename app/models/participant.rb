class Participant < ApplicationRecord
  include PgSearch::Model

  belongs_to :event

  validates :phone_number, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  pg_search_scope :search_by_term,
    against: [ :first_name, :last_name, :phone_number, :email ],
    using: {
      tsearch: { prefix: true, any_word: true }
    }

  scope :simple_search, ->(term) {
    where(
      "first_name ILIKE :q OR last_name ILIKE :q OR phone_number ILIKE :q OR email ILIKE :q",
      q: "%#{term}%"
    )
  }

  # Additional scope for phone number search with normalization
  scope :search_by_phone, ->(term) {
    normalized = term.to_s.gsub(/\A0+/, "")  # Strip leading zeros
    where("LTRIM(phone_number, '0') LIKE ?", "%#{normalized}%")
  }

  scope :smart_search, ->(term) {
    if term.match?(/\A0?\d+\z/)  # Looks like a phone number
      search_by_phone(term)
    else
      search_by_term(term)
    end
  }


  def full_name
    "#{first_name} #{last_name}"
  end
end
