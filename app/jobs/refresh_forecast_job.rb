class RefreshForecastJob < ApplicationJob
  queue_as :default

  def perform(location_id)
    location = Location.find(location_id)
    return if location.latitude.blank? || location.longitude.blank?

    data = ForecastFetcher.new(lat: location.latitude, lng: location.longitude).call

    ForecastDay.transaction do
      location.forecast_days.delete_all
      Array(data).each { |row| location.forecast_days.create!(row) }
    end
  end
end