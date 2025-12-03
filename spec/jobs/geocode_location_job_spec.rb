# spec/jobs/geocode_location_job_spec.rb
require "rails_helper"

RSpec.describe GeocodeLocationJob, type: :job do
  let(:location) do
    Location.create!(name: "Testville", street_address: "123 Main St")
  end

  let(:geo_result) do
    double("Geocoder::Result", latitude: 40.0, longitude: -75.0)
  end

  before do
    allow(Geocoder).to receive(:search).with("123 Main St").and_return([ geo_result ])
    ActiveJob::Base.queue_adapter = :test
  end

  it "sets latitude/longitude and enqueues refresh" do
    # creation enqueues a refresh job; clear that so we assert only the job from the geocode run
    location
    ActiveJob::Base.queue_adapter.enqueued_jobs.clear

    expect {
      described_class.perform_now(location.id)
    }.to have_enqueued_job(RefreshForecastJob)

    location.reload
    expect(location.latitude).to eq(40.0)
    expect(location.longitude).to eq(-75.0)
  end
end
