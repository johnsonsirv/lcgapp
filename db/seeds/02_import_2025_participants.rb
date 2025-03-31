puts "Seeding participants..."
CSV.foreach('db/seeds/2025_participants.csv', headers: true) do |row|
  begin
    puts "Seeding participant: #{row['phone_number']} - name #{row['first_name']} #{row['last_name']}"

    phone_number = row['phone_number']
    first_name = row['first_name']
    last_name = row['last_name']

    participant = Participant.find_by(phone_number: phone_number)
    if participant
      participant.update!(
        first_name: first_name,
        last_name: last_name,
        email: row['email'],
        gender: row['gender'],
        denomination: row['denomination']
      )
    else
      Participant.create(
        phone_number: phone_number,
        first_name: first_name,
        last_name: last_name,
        email: row['email'],
        gender: row['gender'],
        denomination: row['denomination']
      )
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Error seeding participant: #{e.message}")
    puts e.message
  end
end
