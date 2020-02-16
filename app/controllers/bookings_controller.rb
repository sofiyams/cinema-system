class BookingsController < ApplicationController
  load_and_authorize_resource
  before_action :set_user
  before_action :set_movie, only: [:new, :create]
#  before_action :set_booking, only: [:show]

  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = @user.bookings
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    if @movie.showtimes.empty?
      redirect_back fallback_location: @movie, notice: "Sorry, there are no available showtimes for this movie"
      return 
    end 
    @last_booking = @user.bookings.last
    @booking = @user.bookings.new

  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = @user.bookings.new(booking_params)
    @booking.movie = @movie
    respond_to do |format|
      if @booking.save
        format.html { redirect_to user_bookings_path(@user), notice: 'Booking was successfully created.' }
        format.json { render :show, status: :created, location: @booking }
      else
        format.html { render :new }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = @user.bookings.find_by(id: params[:id])
      if @booking.nil?
        redirect_to user_bookings_path(@user)
      end 
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params.require(:booking).permit(:showtime_id, :title, :first_name, :last_name, :phone_number)
    end 

    def set_user
      user_id = params[:user_id] || current_user&.id
      @user = User.find_by(id: user_id)
      if @user.nil?
        session[:last_visited_path] = request.path
        redirect_to login_path, notice: "You must be logged in to book a movie"
      end 
    end 

    def set_movie
      @movie = Movie.find_by(id: params[:movie_id])
      if @movie.nil?
        redirect_to movies_url
      end 
    end 
end
