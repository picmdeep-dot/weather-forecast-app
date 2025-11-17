require "rails_helper"

RSpec.shared_context "open-meteo stub" do
  before do
    stub_request(:get, "https://api.open-meteo.com/v1/forecast")
      .with(
        query: hash_including(
          "latitude" => "41.8781",
          "longitude" => "-87.6298",
          "temperature_unit" => "fahrenheit",
          "timezone" => "auto"
        )
      )
      .to_return(
        status: 200,
        body: {
          daily: {
            time: [ "2025-01-01", "2025-01-02" ],
            temperature_2m_max: [ 32.0, 35.0 ],
            temperature_2m_min: [ 20.0, 22.0 ],
            weathercode: [ 0, 3 ]
          }
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end
end

RSpec.describe ForecastFetcher do
  let(:lat) { 41.88 }
  let(:lng) { -87.63 }

  let(:api_url) { "https://api.open-meteo.com/v1/forecast" }

  let(:query_matcher) do
    hash_including(
      "latitude"  => lat.to_s,
      "longitude" => lng.to_s,
      "temperature_unit" => "fahrenheit"
    )
  end

  let(:response_body) do
    {
      daily: {
        time:               [ "2025-01-01", "2025-01-02" ],
        temperature_2m_max: [ 60.5, 62.0 ],
        temperature_2m_min: [ 40.1, 41.2 ],
        weathercode:        [ 0, 61 ] # Clear, Rain
      }
    }.to_json
  end

  it "returns an array of daily hashes with date/high/low/summary" do
    stub_request(:get, api_url)
      .with(query: query_matcher)
      .to_return(
        status: 200,
        body: response_body,
        headers: { "Content-Type" => "application/json" }
      )

    result = described_class.new(lat: lat, lng: lng).call

    expect(result).to be_an(Array)
    expect(result.size).to eq(2)

    first = result.first
    expect(first[:date]).to eq(Date.new(2025, 1, 1))
    expect(first[:high_f]).to eq(60.5)
    expect(first[:low_f]).to eq(40.1)
    expect(first[:summary]).to eq("Clear")
  end

  it "returns [] when the response is missing daily data" do
    stub_request(:get, api_url)
      .with(query: query_matcher)
      .to_return(
        status: 200,
        body: {}.to_json,
        headers: { "Content-Type" => "application/json" }
      )

    result = described_class.new(lat: lat, lng: lng).call

    expect(result).to eq([])
  end
end
