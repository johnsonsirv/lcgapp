puts "Seeding events... "

# Create events
Event.destroy_all

Event.create!(
  name: "LCG 2025",
  description: "This is the Leadership and Church Growth Conference 2025 - theme LEGACY",
  theme: "LEGACY",
  year: "2025",
  registration_status: "open", # or "closed" depending on your use cas
  start_date: Date.new(2025, 4, 3),
  end_date: Date.new(2025, 4, 5),
  location: "In-grace Event Centre, Rangers Ave. Enugu",
)
