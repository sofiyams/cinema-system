class Movie < ApplicationRecord
  belongs_to :user
  has_many :showtimes, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :ticket_types, dependent: :destroy
  has_many :user_watchlists, dependent: :destroy
  has_many :reviews
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  resourcify
  
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  validates :name, :presence => { :message => "cannot be blank ..."}
	validates :name, :length => {:in => 2..50, :message => "must be between two and fifty characters"}

  validates :description, :presence => { :message => "cannot be blank ..."}
	validates :description, :length => {:maximum => 500, :message => "maximum length 500 characters"} 

  validates :actors, :presence => { :message => "cannot be blank ..."}
	validates :actors, :length => {:in => 2..50, :message => "must be between two and fifty characters"}

  validates :director, :presence => { :message => "cannot be blank ..."}
	validates :director, :length => {:in => 2..50, :message => "must be between two and fifty characters"}

  validates :language, :presence => { :message => "cannot be blank ..."}
  validates :language, :length => {:in => 2..50, :message => "must be between two and fifty characters"}
  
  validates :duration, :numericality => {:greater_than_or_equal_to => 75, :allow_blank => true, :message => "must be a positive value"}
  
  validates :user_id, presence: true

  def available_showtimes
    showtimes.select(&:available?)
  end

  def self.bookable
    joins(:showtimes).where("showtimes.date > ?", Date.today.strftime("%Y-%m-%d"))
  end

  def average_rating
    ratings = reviews.pluck(:rating).compact
    return 0 if ratings.size.zero?
    ratings.sum / ratings.size
  end 

end
