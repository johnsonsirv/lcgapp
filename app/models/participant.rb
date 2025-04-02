class Participant < ApplicationRecord
  belongs_to :event

  validates :phone_number, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  searchkick word_start: [:phone_number, :first_name, :last_name],
            searchable: [:phone_number, :first_name, :last_name]

  def search_data
    {
      phone_number: phone_number,
      first_name: first_name,
      last_name: last_name,
      email: email,
      event_id: event_id
    }
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
