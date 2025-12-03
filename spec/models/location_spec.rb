require "rails_helper"

RSpec.describe Location, type: :model do
  describe "validations" do
    it "is invalid without a name" do
      location = Location.new(street_address: "Chicago, IL")
      expect(location).not_to be_valid
      expect(location.errors[:name]).to be_present
    end

    it "is invalid without ip or address" do
      location = Location.new(name: "Nowhere")
      expect(location).not_to be_valid
      expect(location.errors[:base]).to include("Provide an IP address or a text address")
    end

    it "is valid with a street address" do
      location = Location.new(name: "Chicago", street_address: "Chicago, IL")
      expect(location).to be_valid
    end
  end

  describe "associations" do
    it "has many forecast_days, dependent destroy" do
      location = Location.create!(name: "Test", latitude: 1.0, longitude: 2.0, street_address: "x")
      day = location.forecast_days.create!(date: Date.today, high_f: 70, low_f: 50, summary: "Clear")

      expect(location.forecast_days).to include(day)

      expect {
        location.destroy
      }.to change { ForecastDay.count }.by(-1)
    end
  end

  describe "callbacks" do
    include ActiveJob::TestHelper
    it "enqueues RefreshForecastJob after create" do
      ActiveJob::Base.queue_adapter = :test

      expect {
        Location.create!(name: "Chicago", street_address: "Chicago, IL")
      }.to have_enqueued_job(RefreshForecastJob)
    end
  end
end
