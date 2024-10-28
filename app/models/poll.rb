class Poll < ApplicationRecord
  belongs_to :riding
  belongs_to :polling_location, optional: true

  validates :number, presence: true
  validate :valid_riding, on: :create

  # Suggests next poll number to users
  def self.next_poll_number
    poll = select('CAST(number AS INTEGER)').order('number desc').limit(1)
    poll.any? ? poll[0].number.to_i + 10 : 10
  end

  # Validates whether the poll number exists under the same riding
  def valid_riding
    existing_poll = Poll.where('riding_id = ? AND number = ?', self.riding_id.to_i, self.number.to_s)
    errors.add(:base, 'Poll already exists under this Riding.') if existing_poll.any?
  end
end
