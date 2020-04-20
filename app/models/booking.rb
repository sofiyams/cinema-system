class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :movie
  belongs_to :showtime
  has_many   :tickets, dependent: :destroy

  validates :title, :first_name, :last_name, :phone_number, presence: true 

  validates :phone_number, :numericality => true, length:{is:11}
  validate :available_showtime
  validate :has_tickets

  # expects ticket_types to be of the form:
  # {ticket_type_name: qty}
  # e.g {adult: 2}
  def build_tickets(ticket_types)
    new_tickets = []
    ticket_types.each do |name, qty|
      # todo: validate invalid ticket type
      movie_ticket_type = movie.ticket_types.find_by!(name: name)
      qty.to_i.times { new_tickets <<  tickets.new(ticket_type: movie_ticket_type) }
    end

    new_tickets
  end

  def tickets_brkdwn
    brkdwn = {}
    tickets.group(:ticket_type_id).count.each do |id,count| 
      brkdwn[TicketType.find(id)] = count
    end
    brkdwn
  end

  def total_price
    total = 0
    tickets_brkdwn.each {|ticket_type, count| total += ticket_type.price * count}
    total
  end 


  private

  def available_showtime
    unless showtime.available?
      errors.add(:showtime, "The showtime you have selected is no longer available")
    end 
  end

  def has_tickets
    if tickets.empty?
      errors.add(:tickets, "are empty. Please add tickets to book movie")
    end
  end
end
