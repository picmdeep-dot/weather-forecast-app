class ForecastDay < ApplicationRecord
  belongs_to :location
  validates :date, presence: true
end
