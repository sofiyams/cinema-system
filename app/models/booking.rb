class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :movie
  belongs_to :showtime

  validates :title, :first_name, :last_name, :phone_number, presence: true 

  validates :phone_number, :numericality => true, length:{is:11}
  validate :future_showtime

  private

  def future_showtime
    if showtime.past?
      errors.add(:showtime, "The showtime you have selected is in the past")
    end 
  end
end
