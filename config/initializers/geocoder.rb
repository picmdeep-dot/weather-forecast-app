Geocoder.configure(
  timeout: 5,
  units: :mi,
  ip_lookup: :ipinfo_io,

  http_headers: {"User-Agent" => "weather-forecast-app (localhost; contact: yourEmail@example.com)"}
)