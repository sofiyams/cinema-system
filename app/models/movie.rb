class Movie < ActiveRecord::Base
  belongs_to :user
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
	def date_format
		if self.date !=nil
			self.date = date.strftime("%d-%m-%Y") 
		end
  end
  
end
