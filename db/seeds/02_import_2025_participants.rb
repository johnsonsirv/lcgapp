require 'csv'

puts "Seeding participants..."

@event = Event.find_by(year: 2025)
if @event.nil?
  puts "Event not found for year 2025"
  exit
end

# puts "purging participants..."
# @event.participants.destroy_all
tot_created= 0
tot_updated= 0

CSV.foreach('db/seeds/2025_masterlist_list.csv', headers: true) do |row|
  begin
    puts "Seeding participant: #{row['PHONE_NUMBER']} - name #{row['FIRST_NAME']} #{row['LAST_NAME']}"

    phone_number = row['PHONE_NUMBER']
    first_name = row['FIRST_NAME']
    last_name = row['LAST_NAME']

    participant = @event.participants.find_by(phone_number: phone_number)
    if participant
      # participant.update!(
      #   first_name: first_name.downcase,
      #   last_name: last_name.downcase,
      #   email: row['EMAIL'],
      #   middle_name: row['MIDDLE_NAME']
      # )
      tot_updated += 1
    else
      @event.participants.create(
        phone_number: phone_number,
        first_name: first_name.downcase,
        last_name: last_name.downcase,
        middle_name: row['MIDDLE_NAME'],
        email: row['EMAIL']
      )
      tot_created += 1
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Error seeding participant: #{e.message}")
    puts e.message
  end
end

puts "Total created: #{tot_created}"
puts "Total updated: #{tot_updated}"
