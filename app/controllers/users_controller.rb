class UsersController < ApplicationController

  def new
    @user = User.new
  end 
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the De Montfort Cinema #{@user.username}"
      redirect_to movies_path
    else
      render 'new'
    end
  end 



  private 
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end 

end 