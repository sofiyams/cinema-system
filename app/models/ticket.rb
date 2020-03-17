class Ticket < ApplicationRecord
  belongs_to :booking
  belongs_to :ticket_type
end
