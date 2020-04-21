class TicketType < ApplicationRecord
  belongs_to :movie
  has_many   :tickets, dependent: :destroy

  DefaultPricing = {
    "Adults (15+)" => 7,
    "Children (14 & Under)" => 5,
    "Student (ID Required)" => 6,
 }.freeze

 validates_uniqueness_of :name, scope: [:movie_id]
end