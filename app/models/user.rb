class User < ApplicationRecord
  rolify
    has_many :movies
    has_many :bookings
    has_many :user_watchlists, dependent: :destroy
    before_save { self.email = email.downcase }
    after_create :assign_default_role

    validates :username, presence: true,
    uniqueness: { case_sensitive: false },
    length: { minimum: 3, maximum: 25 }

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 105 },
    uniqueness: { case_sensitive: false },
    format: { with: VALID_EMAIL_REGEX }

    validates :points, numericality: {only_integer:true}

    has_secure_password

    def assign_default_role
      self.add_role(:user) if self.roles.blank?
    end 

    def applicable_discount
      (points / 250) * 5
    end

    def watchlist
      user_watchlists.map(&:movie)
    end 

    def watchlist_includes?(movie)
      user_watchlists.where(movie: movie).present?
    end

end