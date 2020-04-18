class Showtime < ApplicationRecord
  TOTAL_SEATS = '16'.freeze

  belongs_to :movie
  has_many :bookings

  validate :showtime_is_unique
  validates_date :date, :on_or_after => :today # See Restriction Shorthand.

  def form_dropdown
    "#{date} (#{time.strftime('%H:%M')})"
  end

  # A showtime is available if these conditions are met:
  ## it's in the future 
  ## it has empty seats
  def available?
    !(past? || available_seat_nums.empty?)
  end

  def past?
    date_time = DateTime.strptime(form_dropdown, "%Y-%m-%d (%H:%M)")
    date_time.past?
  end

  def available_seat_nums
    # total seats - occupied_seat_nums
    ('1'..TOTAL_SEATS).to_a - occupied_seat_nums
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
