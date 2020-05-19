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
        images: [@booking.movie.image.url]
      }
    end

    if params["redeem_points"] == "true"
      items = [{
        name: "Discounted tickets for movie, #{@booking.movie.name}",
        amount: ((@booking.total_price - @user.applicable_discount) * 100).to_i,
        currency: 'gbp',
        quantity: 1
      }]
    end

    success_url = success_payments_url(booking_id:@booking.id, applied_discount:@user.applicable_discount) + "&session_id={CHECKOUT_SESSION_ID}"
    session = Stripe::Checkout::Session.create({
    success_url: success_url, 
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
  session_id = params["session_id"]
  session = Stripe::Checkout::Session.retrieve(session_id)
  payment = Stripe::PaymentIntent.retrieve(session["payment_intent"])
  new_points = current_user.points + (payment["amount"] / 100 * 5)
  if params["applied_discount"].present?
    new_points -= params["applied_discount"].to_i * 50
  end 
  current_user.update!(points:new_points)
  notice = "Your transaction was successful and your points have been updated to #{new_points}"
  redirect_to user_booking_path(current_user,@booking),notice: notice
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

