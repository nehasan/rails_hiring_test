class PollCreator < ApplicationService
  attr_accessor :riding_id,
                :polling_location_id,
                :assign_to,
                :poll_number,
                :title, 
                :address, 
                :city, 
                :postal_code

  def initialize(riding_id, polling_location_id, assign_to, poll_number, title, address, city, postal_code)
    @riding_id = riding_id
    @polling_location_id = polling_location_id
    @assign_to = assign_to
    @poll_number = poll_number
    @title = title
    @address = address
    @city = city
    @postal_code = postal_code
  end

  def call
    create_poll
  end

  private

  def create_poll
    ActiveRecord::Base.transaction do

      # Polling location assignment is optional
      poll_loc_id = nil
      if @assign_to == 'new'
        # Create a new polling location and assign the poll to it
        created_polling_location = PollingLocation.create(
          title: @title,
          address: @address,
          city: @city,
          postal_code: @postal_code
        )
        return errors.add(:base, 'Polling Location cannot be created') if created_polling_location.nil?

        poll_loc_id = created_polling_location.id

      elsif @assign_to == 'existing'
        return errors.add(:base, 'Polling Location id does not exist or has not provided.') if @polling_location_id.blank?
        
        # Assign the poll to this existing polling location
        poll_loc_id = @polling_location_id

      end

      # Finally create the poll and exit the process
      created_poll = Poll.create(
          riding_id: @riding_id,
          polling_location_id: poll_loc_id,
          number: @poll_number
        )

      return errors.add(:base, 'Poll cannot be created due to error') if created_poll.nil?

      return created_poll

    end
  end
end