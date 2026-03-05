puts "Seeding events..."

event = Event.find_or_create_by!(year: 2026) do |e|
  e.name = "LCG 2026"
  e.theme = "TAKE THE LEAD"
  e.description = "Leadership and Church Growth Conference 2026 - theme TAKE THE LEAD"
  e.start_date = Date.new(2026, 3, 5)
  e.end_date = Date.new(2026, 3, 7)
  e.location = "In-grace Event Centre, Rangers Ave. Enugu"
  e.status = :open
  e.short_url = "bit.ly/LCG2026"
end

puts event.previously_new_record? ? "Created event: #{event.name}" : "Event already exists: #{event.name}"
