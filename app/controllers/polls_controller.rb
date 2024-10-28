class PollsController < ApplicationController
  # Need to configure authentication methods here

  # POST /polls or /polls.json
  def create
    verified = poll_params
    respond_to do |format|
      created_poll = PollCreator.call(
                      params[:riding_id],
                      verified[:polling_location_id],
                      verified[:assign_to],
                      verified[:poll_number],
                      verified[:title],
                      verified[:address],
                      verified[:city],
                      verified[:postal_code],
                    )

      if created_poll.present?
        format.json { render json: created_poll, status: :ok }
      else
        format.json { render json: created_poll.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def poll_params
    params.require(:polls)
      .permit(
        :polling_location_id,
        :assign_to,
        :poll_number, 
        :title, 
        :address, 
        :city, 
        :postal_code
      )
  end
end
