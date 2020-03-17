class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :movie
  belongs_to :showtime
  has_many   :tickets, dependent: :destroy

  validates :title, :first_name, :last_name, :phone_number, presence: true 

  validates :phone_number, :numericality => true, length:{is:11}
  validate :future_showtime

  # expects ticket_types to be of the form:
  # {ticket_type_name: qty}
  # e.g {adult: 2}
  def create_tickets(ticket_types)
    ticket_types.each do |name, qty|
      # todo: validate invalid ticket type
      movie_ticket_type = movie.ticket_types.find_by!(name: name)
      qty.to_i.times { tickets.create!(ticket_type: movie_ticket_type) }
    end
  end

  def tickets_brkdwn
    brkdwn = {}
    tickets.group(:ticket_type_id).count.each do |id,count| 
      brkdwn[TicketType.find(id)] = count
    end
    brkdwn
  end


  private

  def future_showtime
    if showtime.past?
      errors.add(:showtime, "The showtime you have selected is in the past")
    end 
  end
end
