class ForecastFetcher
  OPEN_METEO_URL = "https://api.open-meteo.com/v1/forecast".freeze

  def initialize(lat:, lng:)
    @lat = lat
    @lng = lng
  end

  def call
    conn = Faraday.new(OPEN_METEO_URL)
    resp = conn.get("", {
    latitude: @lat,
    longitude: @lng,
    daily: %w[temperature_2m_max temperature_2m_min weathercode],
    temperature_unit: "fahrenheit",
    timezone: "auto"
    })

    raise "Forecast error: #{resp.status}" unless resp.success?


    json = JSON.parse(resp.body)
    days = json.dig("daily", "time")
    highs = json.dig("daily", "temperature_2m_max")
    lows = json.dig("daily", "temperature_2m_min")
    codes = json.dig("daily", "weathercode")

    Array(days).each_with_index.map do |d, i|
      {
        date: Date.parse(d),
        high_f: highs[i],
        low_f: lows[i],
        summary: weathercode_to_summary(codes[i])
      }
    end
  end

  private

  def weathercode_to_summary(code)
    case code
    when 0 then "Clear"
    when 1,2 then "Mostly clear"
    when 3 then "Overcast"
    when 45,48 then "Fog"
    when 51,53,55 then "Drizzle"
    when 61,63,65 then "Rain"
    when 71,73,75 then "Snow"
    when 95 then "Thunderstorm"
    else "—"
    end
  end
end