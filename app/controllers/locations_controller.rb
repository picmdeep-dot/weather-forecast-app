class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  def index
    @locations = Location.order(:name)
    @location = Location.new
  end

  def show
    @forecast_days = @location.forecast_days.order(:date)
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
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
