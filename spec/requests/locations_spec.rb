require "rails_helper"

RSpec.describe "Locations", type: :request do
  it "creates a location by address and redirects to show" do
    geocoder_result = double("Geocoder::Result",
      latitude: 41.8781,
      longitude: -87.6298
    )
    allow(Geocoder).to receive(:search).and_return([geocoder_result])

    post "/locations", params: {
      mode: "address",
      location: {
        name: "Chicago",
        street_address: "Chicago, IL"
      }
    }

    location = Location.last
    expect(response).to redirect_to(location_path(location))
    follow_redirect!

    expect(response.body).to include("Chicago")
    expect(location.latitude).to be_present
    expect(location.longitude).to be_present
  end
end
