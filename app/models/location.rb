class Location < ApplicationRecord
  has_many :forecast_days, dependent: :destroy

  validates :name, presence: true
  validate :ip_or_address_present

  before_validation :strip_blanks
  after_commit :refresh_forecast_async, on: [ :create, :update ]

  def ip_or_address_present
    if ip_address.blank? && street_address.blank?
      errors.add(:base, "Provide an IP address or a text address")
    end
  end

  def strip_blanks
    self.name = name&.strip
    self.ip_address = ip_address&.strip
    self.street_address = street_address&.strip
  end

  def display_name
    if street_address.present?
      street_address
    elsif ip_address.present?
      ip_based_display_name || ip_address
    else
      name.presence || "(Unnamed location)"
    end
  end

  after_create_commit :enqueue_geocode_job
  after_update_commit :enqueue_geocode_job, if: :address_or_ip_changed?

  def enqueue_geocode_job
    GeocodeLocationJob.perform_later(id)
  end

  def address_or_ip_changed?
    saved_change_to_ip_address? || saved_change_to_street_address?
  end

  # Check if forecast is current, update if not
  def refresh_forecast_if_stale!
    return if forecast_fresh?
    ForecastUpdater.new(location: self).call
  end

  def refresh_forecast_async
    RefreshForecastJob.perform_later(id)
  end

  private

  def ip_based_display_name
    result = Geocoder.search(ip_address).first
    return unless result
    parts = [
      safe_result_attr(result, :city),
      safe_result_attr(result, :state),
      safe_result_attr(result, :country)
    ].compact

    return if parts.empty?

    parts.join(", ")
  rescue => e
    Rails.logger.warn("[Location#reverse_geocode_name] #{e.class}: #{e.message}")
    nil
  end

  def safe_result_attr(result, method)
    if result.respond_to?(method)
      result.public_send(method)
    elsif result.is_a?(Hash)
      # in case hash result
      result[method.to_s] || result[method]
    end
  end

  def forecast_fresh?
    return false if forecast_refreshed_at.blank?
    forecast_refreshed_at > 6.hours.ago
  end
end
