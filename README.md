```markdown
# 🌤️ Weather Locations App

A lightweight Ruby on Rails application that allows users to:

- Save locations using **street address** or **IP address**
- Automatically geocode each location
- Display a **7-day weather forecast** using Open-Meteo
- Highlight daily **high/low** temperatures
- Optionally display a **chart** of highs/lows (Stimulus + Chart.js)
- Perform CRUD operations with **Turbo/Stimulus enhancements**

This project was built as part of a take-home assignment to demonstrate knowledge of Rails, API integration, modern Rails frontend (Turbo/Stimulus), and basic test coverage.

---

## 📦 Tech Stack

- **Ruby 3.3+**
- **Rails 8.x**
- **TailwindCSS**
- **Geocoder** (Nominatim + IP services)
- **Open-Meteo API**
- **Turbo Streams & Stimulus**
- **RSpec** (unit + system tests)

---

# 🚀 Getting Started (Local Development)

## 1. Clone the repository

```bash
git clone https://github.com/yourname/weather-locations.git
cd weather-locations
```

---

## 2. Install dependencies

```bash
bundle install
```

---

## 3. Set up the database

PostgreSQL:

```bash
rails db:create
rails db:migrate
```

SQLite:

```bash
rails db:migrate
```

---

## 4. Configure Geocoder (Required)

Nominatim requires a valid **User-Agent** with an email address.

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

Without this, address lookups **will fail**.

---

## 5. Start the server

```bash
bin/dev
```

or:

```bash
rails server
```

Open:

```
http://localhost:3000
```

---

# 🌎 Features

## ✓ Add Locations (Address or IP)

Users can add a location in one of two modes:

- **Street address** — geocoded via Nominatim  
- **IP address** — geolocated to approximate region  

A Stimulus controller toggles the form fields dynamically.

---

## ✓ Location List

Each card displays:

- Name  
- Friendly derived location label (e.g., “Chicago, IL”)  
- Underlying IP (if applicable)  
- Edit/Delete actions  

Turbo Streams update the list instantly after creation or deletion.

---

## ✓ 7-Day Weather Forecast

Uses Open-Meteo to display:

- Daily high temperatures  
- Daily low temperatures  
- Dates  

High/lows visually highlighted.

---

## ✓ Chart.js Temperature Graph (Bonus)

A Stimulus controller loads a Chart.js line graph showing:

- Highs (red)  
- Lows (blue)  

Only loads when viewing a location’s detail page.

---

# 🧪 Testing

The project includes:

- Model tests  
- Service tests (`ForecastFetcher`)  
- System tests (Turbo + UI behavior)  

Run all tests:

```bash
bundle exec rspec
```

Recommended before deployment:

```bash
RAILS_ENV=test bundle exec rspec
rails db:migrate RAILS_ENV=production
```

---

# 📁 Project Structure (Simplified)

```
app/
  models/location.rb
  controllers/locations_controller.rb
  services/forecast_fetcher.rb
  views/locations/
    index.html.erb
    show.html.erb
    _form.html.erb
    _location.html.erb
    create.turbo_stream.erb
  javascript/controllers/
    location_form_controller.js
    forecast_chart_controller.js

config/
  initializers/geocoder.rb

spec/
  models/
  services/
  system/
```

---

# 🚀 Deployment

Deployable to:

- **Render**
- **Fly.io**
- **Heroku**  

No environment variables required unless swapping geocoding providers.

---

# 📝 Notes for Reviewers

- Uses **conventional Rails structure** and avoids unnecessary abstractions  
- Turbo/Stimulus used intentionally to demonstrate modern Rails practices  
- External API calls are wrapped in a service object for testability  
- API interactions are stubbed in RSpec for deterministic tests  
- UI intentionally clean and minimal via TailwindCSS  

---

# 📜 License

MIT (or your preferred license)
```
