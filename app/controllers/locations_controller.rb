class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  def index
    @locations = Location.order(:name)
    @location = Location.new
  end

  def show
    @location = Location.find(params[:id])
    @location.refresh_forecast_if_stale!
    @forecast_days = @location.forecast_days.order(:date)
  end

  def new
    @location = Location.new
  end

  def create
    attributes = location_params.to_h
    mode = params[:mode] # "ip" or "street address" from form selection

    if mode =="ip"
      ip = if Rails.env.development?
        # TEMP hardcoded value for local testing
        "8.8.8.8"
      else
        request.remote_ip
      end
      attributes["ip_address"] = ip if attributes["ip_address"].blank?
      attributes["street_address"] = nil
    elsif mode == "address"
      attributes["ip_address"] = nil if attributes["street_address"].present?
    end

    @location = Location.new(attributes)
    if @location.save
      respond_to do |format|
        format.html { redirect_to @location, notice: "Location created" }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :form_errors, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    if @location.update(location_params)
      redirect_to @location, notice: "Location updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_path, notice: "Location deleted" }
      format.turbo_stream
    end
  end

  private
  def set_location
    @location = Location.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:name, :ip_address, :street_address)
  end
end
