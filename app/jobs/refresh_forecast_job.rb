class RefreshForecastJob < ApplicationJob
  queue_as :default

  def perform(location_id)
    location = Location.find(location_id)
    ForecastUpdater.new(location: location).call
  end
end
