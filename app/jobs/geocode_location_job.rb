class GeocodeLocationJob < ApplicationJob
  queue_as :default

  def perform(location_id)
    location = Location.find_by(id: location_id)
    return unless location

    # don't run if already geocoded
    return if location.latitude.present? && location.longitude.present?

    query = if location.street_address.present?
      location.street_address
    elsif location.ip_address.present?
      location.ip_address
    end

    return if query.blank?

    result = Geocoder.search(query).first
    return unless result

    lat = if result.respond_to?(:latitude)
      result.latitude
    else
      result["lat"] || result[:lat]
    end

    lng = if result.respond_to?(:longitude)
      result.longitude
    else
      result["lon"] || result[:lon] || result["lng"] || result[:lng]
    end

    location.update_columns(latitude: lat, longitude: lng)

    RefreshForecastJob.perform_later(location.id)
  rescue => e
    Rails.logger.warn("[GeocodeLocationJob] #{e.class}: #{e.message}")
  end
end
