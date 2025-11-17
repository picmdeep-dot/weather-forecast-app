<<<<<<< HEAD
# weather-forecast-app
Simple weather forecast application that allows a user to set multiple locations and see the forecast for each location
=======
# Weather Locations App

A lightweight Ruby on Rails application that allows users to:

- Save locations using **street address** or **IP address**
- Automatically geocode each location
- Display a **7-day weather forecast** using Open-Meteo
- Highlight daily **high/low** temperatures
- Optionally display a **chart** of highs/lows (Stimulus + Chart.js)
- Perform CRUD operations with **Turbo/Stimulus enhancements**

---

## Tech Stack

- **Ruby 3.4+**
- **Rails 8.x**
- **TailwindCSS** (via `tailwindcss-rails`)
- **SQLite** (local development)
- **Geocoder** (Nominatim + IP lookup)
- **Open-Meteo API**
- **Turbo Streams & Stimulus**
- **RSpec** (unit + system tests)

---

# Getting Started (Local Development)

## 1. Clone the repository

```bash
git clone https://github.com/yourname/weather-locations.git
cd weather-locations
```

---

## 2. Install Ruby dependencies

```bash
bundle install
```

This installs Rails, Tailwind, Geocoder, RSpec, and all other gems.

---

## 3. Set up the database (SQLite for local)

SQLite is used for development and testing.

```bash
bin/rails db:setup
```

This will:

- Create dev & test SQLite DB files  
- Load the schema  
- Seed data (if present)

Or manually:

```bash
bin/rails db:create
bin/rails db:migrate
```

---

## 4. Configure Geocoder (Required)

Nominatim requires a User-Agent header with your email.

Edit:

```
config/initializers/geocoder.rb
```

Example:

```ruby
Geocoder.configure(
  lookup: :nominatim,
  use_https: true,
  http_headers: {
    "User-Agent" => "weather-locations-app (your_email@example.com)"
  }
)
```

If omitted, address lookups will fail.

---

## 5. Run the application (with Tailwind)

Recommended:

```bash
bin/dev
```

This runs:

- Rails server  
- Tailwind watcher  

Then visit:

```
http://localhost:3000
```

### Running Rails and Tailwind separately

**Rails server:**

```bash
bin/rails server
```

**Tailwind watcher:**

```bash
bin/rails tailwindcss:watch
```

---

# Features

## ✓ Add Locations (Address or IP)

- Street address → geocoded via Nominatim  
- IP address → approximate geolocation  
- Stimulus controller toggles input fields  

---

## ✓ Location List

Each location card shows:

- Name  
- Friendly region  
- IP address (if applicable)  
- Edit/Delete actions  

Turbo Streams update the UI immediately.

---

## ✓ 7-Day Weather Forecast

Displays:

- High temperature  
- Low temperature  
- Full 7-day span  

Powered by Open-Meteo.

---

## ✓ Temperature Chart (Optional)

Stimulus + Chart.js:

- Highs = red  
- Lows = blue  

Rendered only on the show page.

---

# Testing

Includes:

- Model specs  
- Service specs (`ForecastFetcher`)  
- System specs (Turbo/Stimulus UI behavior)

Run all tests:

```bash
bundle exec rspec
```

Recommended before committing:

```bash
RAILS_ENV=test bundle exec rspec
```

>>>>>>> feature/create-multi-location-weather-forecast-app
