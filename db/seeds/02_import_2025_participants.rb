require 'csv'

puts "Seeding participants..."

@event = Event.find_by(year: 2025)
if @event.nil?
  puts "Event not found for year 2025"
  exit
end

# Load existing phone numbers to check for duplicates
existing_phones = @event.participants.pluck(:phone_number).to_set

records_to_insert = []
tot_skipped = 0
tot_invalid = 0

CSV.foreach('db/seeds/2025_masterlist_list.csv', headers: true) do |row|
  phone_number = row['PHONE_NUMBER']

  if phone_number.blank?
    tot_invalid += 1
    next
  end

  if existing_phones.include?(phone_number)
    tot_skipped += 1
    next
  end

  records_to_insert << {
    id: SecureRandom.uuid,
    event_id: @event.id,
    phone_number: phone_number,
    first_name: row['FIRST_NAME']&.downcase,
    last_name: row['LAST_NAME']&.downcase,
    middle_name: row['MIDDLE_NAME'],
    email: row['EMAIL'],
    created_at: Time.current,
    updated_at: Time.current
  }
end

# Bulk insert in batches of 1000
tot_created = 0
records_to_insert.each_slice(1000) do |batch|
  result = Participant.insert_all(batch)
  tot_created += result.count
  puts "Inserted batch of #{result.count} participants..."
end

puts "Total created: #{tot_created}"
puts "Total skipped (already exist): #{tot_skipped}"
