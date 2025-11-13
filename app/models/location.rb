class Location < ApplicationRecord
  has_many :forecast_days, dependent: :destroy

  validates :name, presence: true
  validate :ip_or_address_present

  before_validation :strip_blanks
  before_save :geocode_if_needed
  after_commit :refresh_forecast_async, on: [:create, :update]

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

  def geocode_if_needed
    return if latitude.present? && longitude.present?

    if street_address.present?
      result = Geocoder.search(street_address).first
      if result
        self.latitude  = result.respond_to?(:latitude) ? result.latitude : result["lat"]
        self.longitude = result.respond_to?(:longitude) ? result.longitude : result["lon"]
      else
        errors.add(:street_address, "could not be geocoded")
      end
    elsif ip_address.present?
      result = Geocoder.search(ip_address).first
      if result
        self.latitude  = result.respond_to?(:latitude) ? result.latitude : result["lat"]
        self.longitude = result.respond_to?(:longitude) ? result.longitude : result["lon"]
      else
        errors.add(:ip_address, "could not be geocoded")
      end
    end
  end

  # Keep it simple: run inline using ActiveJob (default async adapter ok for dev)
  def refresh_forecast_async
    RefreshForecastJob.perform_later(id)
  end
end
