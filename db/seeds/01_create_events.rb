puts "Seeding events... "

# Create events
Event.includes(:participants).each do |event|
  event.participants.destroy_all
end
Event.destroy_all

Event.create!(
  name: "LCG 2025",
  theme: "LEGACY",
  year: 2025,
  description: "Leadership and Church Growth Conference 2025 - theme LEGACY",
  start_date: Date.new(2025, 4, 3),
  end_date: Date.new(2025, 4, 5),
  location: "In-grace Event Centre, Rangers Ave. Enugu",
  status: :open,
  short_url: "bit.ly/LCG2025"
)
