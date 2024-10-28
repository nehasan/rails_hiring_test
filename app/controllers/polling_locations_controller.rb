class PollingLocationsController < ApplicationController
  before_action :set_polling_location, only: %i[ update ]

  # PUT /polling_locations or /polling_locations.json
  def update
    # puts "--- params #{params}"
    respond_to do |format|
      if @polling_location.update(polling_location_params)
        format.json {render json: @polling_location, status: :ok }
      else
        format.json {render json: @polling_location.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_polling_location
    @polling_location = PollingLocation.find(params[:id])
  end

  def polling_location_params
    params.require(:polling_location)
      .permit(
        :title, 
        :address, 
        :city, 
        :postal_code
      )
  end 
end
