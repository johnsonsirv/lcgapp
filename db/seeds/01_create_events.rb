puts "Seeding events... "

# Create events
Event.includes(:participants).each do |event|
  event.participants.destroy_all
end

Event.destroy_all

Event.create!(
  name: "LCG 2026",
  theme: "TAKE THE LEAD",
  year: 2026,
  description: "Leadership and Church Growth Conference 2026 - theme TAKE THE LEAD",
  start_date: Date.new(2026, 3, 5),
  end_date: Date.new(2026, 3, 7),
  location: "In-grace Event Centre, Rangers Ave. Enugu",
  status: :open,
  short_url: "bit.ly/LCG2026"
)
