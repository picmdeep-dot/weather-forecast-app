require "rails_helper"

RSpec.describe "Locations", type: :system do
  include ActiveJob::TestHelper

  before do
    driven_by(:rack_test)

    # Stub Geocoder
    geocoder_result = double("Geocoder::Result",
      latitude: 41.8781,
      longitude: -87.6298
    )
    allow(Geocoder).to receive(:search).and_return([ geocoder_result ])

    # Stub ForecastFetcher
    fake_forecast = [
      { date: Date.today,     high_f: 80, low_f: 60, summary: "Clear" },
      { date: Date.today + 1, high_f: 82, low_f: 61, summary: "Rain" }
    ]
    fetcher_double = double(ForecastFetcher, call: fake_forecast)
    allow(ForecastFetcher).to receive(:new).and_return(fetcher_double)

    ActiveJob::Base.queue_adapter = :test
  end

  it "allows user to create a location by address and see a 7-day forecast" do
    visit root_path

    fill_in "Name", with: "Chicago"
    choose "Enter Location"
    fill_in "City and State (eg: New York City, NY)", with: "Chicago, IL"

    perform_enqueued_jobs do
      click_button "Create Location"
    end

    expect(page).to have_content("Chicago")
    expect(page).to have_content("Lat/Lng:")

    expect(page).to have_content("Clear")
    expect(page).to have_content("Rain")
    expect(page).to have_content("High (°F)")
    expect(page).to have_content("Low (°F)")
  end
end
