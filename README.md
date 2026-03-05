# LCG App

A fast, lightweight event registration check-in application built with Rails API and Next.js.

## Features

- **Live Search**: Real-time participant lookup by name, phone, or email (3+ characters)
- **One-Click Check-in**: Toggle attendance status instantly
- **Phone Number Normalization**: Handles leading zeros (0703 and 703 both work)
- **Bulk Import**: Seed thousands of participants via CSV

## Tech Stack

| Layer | Technology |
|-------|------------|
| Backend | Rails 7, PostgreSQL, pg_search |
| Frontend | Next.js 14, React, TypeScript, Tailwind CSS |
| Deployment | Render (Docker) |

## Quick Start

### Using Docker

```bash
# Start all services
RAILS_MASTER_KEY=$(cat config/master.key) docker-compose up --build

# Seed database
docker-compose exec web bin/rails db:seed
```

### Local Development

- Frontend: http://localhost:3001
- API: http://localhost:3000


### API Endpoints
Method	Endpoint	Description
GET	/api/v1/participants/search?query=<term>	Search participants
PATCH	/api/v1/participants/:id/toggle_attended	Toggle attendance

### Roadmap: QR Code Self-Verification
#### Planned User Journey
1. Pre-Event: Participants receive unique QR code via email/SMS
2. Arrival: Participant scans QR code at event entrance
3. Self Check-in: QR code opens verification page on their phone
4. Confirmation: Participant confirms identity, attendance auto-recorded
5. Notification: Staff dashboard updates in real-time


### Benefits
- Reduces queue times
- Contactless check-in
- Frees up staff for other tasks
- Real-time attendance tracking
- Deployment
- Deploy to Render using the included render.yaml