# spec/jobs/refresh_forecast_job_spec.rb
require "rails_helper"

RSpec.describe RefreshForecastJob, type: :job do
  let(:location) do
    # Lat/lng set directly to avoid geocoding here
    Location.create!(
      name: "Testville",
      latitude: 35.0,
      longitude: -120.0,
      street_address: "Testville"
    )
  end

  let(:fake_forecast) do
    [
      { date: Date.today,     high_f: 80, low_f: 60, summary: "Clear" },
      { date: Date.today + 1, high_f: 82, low_f: 61, summary: "Rain" }
    ]
  end

  before do
    # Stub ForecastFetcher so we don't hit the network
    fetcher_double = instance_double(ForecastFetcher, call: fake_forecast)
    allow(ForecastFetcher).to receive(:new)
      .with(lat: location.latitude, lng: location.longitude)
      .and_return(fetcher_double)
  end

  it "creates forecast_days for the location" do
    expect {
      described_class.perform_now(location.id)
    }.to change { location.forecast_days.count }.from(0).to(2)

    first_day = location.forecast_days.order(:date).first
    expect(first_day.high_f).to eq(80)
    expect(first_day.low_f).to eq(60)
    expect(first_day.summary).to eq("Clear")
  end
end
