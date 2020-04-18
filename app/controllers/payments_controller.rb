class PaymentsController < ApplicationController
#  load_and_authorize_resource except: [:seats, :save_seats]
  before_action :set_user
  before_action :set_booking

  def new
    items = @booking.tickets_brkdwn.map do |ticket_type, count|
      {
        name: "#{count} #{ticket_type.name} ticket for movie, #{@booking.movie.name}",
        amount: (ticket_type.price * 100).to_i,
        currency: 'gbp',
        quantity: count,
        # images: [@booking.movie.img_url]
      }
    end

    session = Stripe::Checkout::Session.create({
    success_url: success_payments_url(booking_id:@booking.id),
    cancel_url: cancel_payments_url(booking_id:@booking.id),
    payment_method_types: ['card'],
    line_items: items,
  })
  render json: {session_id: session.id}
end 

def cancel
  @booking.destroy 
  redirect_to @booking.movie, notice: "Payment was unsuccessful, please try again."
end

def success
  redirect_to user_booking_path(current_user,@booking),notice: "Your transaction was successful"
end





private

  def set_user
    user_id = params[:user_id] || current_user&.id
    @user = User.find_by(id: user_id)
    if @user.nil?
      session[:last_visited_path] = request.path
      render json: {notice: "You must be logged in to book a movie"}
    end 
  end 

  def set_booking
    @booking = @user.bookings.find_by(id: params[:booking_id])
  end

end 

