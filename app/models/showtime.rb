class Showtime < ApplicationRecord
  belongs_to :movie
  has_many :bookings

  validate :showtime_is_unique
  validates_date :date, :on_or_after => :today # See Restriction Shorthand.

  def form_dropdown
    "#{date} (#{time.strftime('%H:%M')})"
  end 

  def past?
    date_time = DateTime.strptime(form_dropdown, "%Y-%m-%d (%H:%M)")
    date_time.past?
  end 

  def occupied_seat_nums
    # go through all bookings and return the seats in the associated tickets
    bookings.map do |booking|
      booking.tickets.map(&:seat_num)
    end.flatten.compact
  end

  private
  def showtime_is_unique
    if self.class.where(date:date, time:time).exists?
      errors.add(:time, "Showtime for this date already exists")
    end 
  end



end
