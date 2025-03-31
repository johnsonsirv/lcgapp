class Participant < ApplicationRecord
  belongs_to :event

  validates :phone_number, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }


  def full_name
    "#{first_name} #{last_name}"
  end
end
