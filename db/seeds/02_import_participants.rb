require 'csv'

puts "Seeding participants..."

@event = Event.find_by(year: 2026)
if @event.nil?
  puts "Event not found for year 2026"
  exit
end

# Load existing phone numbers to skip duplicates
existing_phones = @event.participants.pluck(:phone_number).to_set

records_to_insert = []
tot_skipped = 0
tot_invalid = 0

CSV.foreach('db/seeds/2026_masterlist_list.csv', headers: true) do |row|
  phone_number = row['PHONE_NUMBER']&.strip

  if phone_number.blank?
    tot_invalid += 1
    next
  end

  if existing_phones.include?(phone_number)
    tot_skipped += 1
    next
  end

  existing_phones.add(phone_number)

  records_to_insert << {
    id: SecureRandom.uuid,
    event_id: @event.id,
    phone_number: phone_number,
    first_name: row['FIRST_NAME']&.strip&.downcase,
    last_name: row['LAST_NAME']&.strip&.downcase,
    middle_name: row['MIDDLE_NAME']&.strip,
    email: row['EMAIL']&.strip,
    attended: false,
    created_at: Time.current,
    updated_at: Time.current
  }
end

# Insert all at once
tot_created = 0
if records_to_insert.any?
  result = Participant.insert_all(records_to_insert)
  tot_created = result.count
end

puts "----------------------------------------"
puts "Total created: #{tot_created}"
puts "Total skipped (already exist): #{tot_skipped}"
puts "Total invalid (missing phone): #{tot_invalid}"
puts "Total participants: #{@event.participants.count}"
