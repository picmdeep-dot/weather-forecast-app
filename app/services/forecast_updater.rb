class ForecastUpdater
  def initialize(location:)
    @location = location
  end

  def call
    return if @location.latitude.blank? || @location.longitude.blank?

    data = ForecastFetcher.new(lat: @location.latitude, lng: @location.longitude).call

    ForecastDay.transaction do
      @location.forecast_days.delete_all
      Array(data).each { |row| @location.forecast_days.create!(row) }
    end

    @location.update_column(:forecast_refreshed_at, Time.current)
  end
end
