class BookingsController < ApplicationController
  load_and_authorize_resource except: [:seats, :save_seats]
  before_action :set_user
  before_action :set_movie, only: [:new, :create]
  before_action :set_booking, only: [:seats, :save_seats]
  before_action :has_selected_seats, only: [:seats, :save_seats]
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

  def seats
  end 

  # do this in the tickets controller 
  # what if user does not select any seats?
  # what if user does not select enough seats?
  # what if seat was taken after user had made the selection
  def save_seats
   # seat is not occupied
   occupied_seats = @booking.showtime.occupied_seat_nums
   booking_tickets = @booking.tickets.where(seat_num: nil)
   index = 0

   params[:seats].uniq.each do |seat_num|
    break if index >= booking_tickets.size
    next if occupied_seats.include? seat_num
    
    booking_tickets[index].update(seat_num: seat_num)
    index += 1
   end

   redirect_to user_bookings_path(@user)
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
        @booking.create_tickets(ticket_types_params)
        format.html { redirect_to seats_movie_booking_path(@movie,@booking) }
        format.json { render :show, status: :created, location: @booking }
      else
        format.html { render :new }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    msg = "booking successfully cancelled"
    unless @booking.destroy
    msg = @booking.errors.full_messages
    end 
    redirect_to user_bookings_path(@user), notice: msg 
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
    
    def ticket_types_params
      params.require(:ticket_type).permit!
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

    def set_booking
      @booking = @user.bookings.find_by(id: params[:id])
      redirect_to movie_path(@movie) if @booking.nil?
    end

    def has_selected_seats
      @booking.tickets.each do |ticket|
      return if ticket.seat_num.nil?
      end
      redirect_to user_bookings_path(@user), notice: "You have already booked seats for this movie"
    end
end
