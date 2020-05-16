class SessionsController < ApplicationController
  before_action :ensure_not_logged_in, except: [:destroy]

  def new

  end 

  def create
    user = User.find_by(username: params[:session][:username])
    if user && user.authenticate(params[:session][:password])    
      session[:user_id] = user.id    
      flash[:success] = "You have successfully logged in"
      redirect_to (session[:last_visited_path] || user_path(user))
    else
      flash.now[:danger] = "There was something wrong with your login information"
      render 'new'
    end
  end
    
  def destroy
    reset_session
    # session[:user_id] = nil
    flash[:success] = "You have logged out"
    redirect_to root_path
  end

  private
  def ensure_not_logged_in
    if current_user.present?
      redirect_to movies_path, notice: "You are already logged in"
    end 
  end
end 