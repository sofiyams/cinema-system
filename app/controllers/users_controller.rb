class UsersController < ApplicationController
  #before_action :set_user, only: [:edit, :update, :show]
  #before_action :require_user, except: [:create, :new, :index, :show]
  #before_action :require_same_user, only: [:edit, :update, :show]
  load_and_authorize_resource


  def index 
    @users = User.paginate(page: params[:page], per_page: 5)
  end 

  def new
    @user = User.new
  end 
  
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to the De Montfort Cinema #{@user.username}"
      redirect_to root_path
    else
      render 'new'
    end
  end 

  def edit

  end 

  def update
    @user.roles = Role.where(id: params['user']['_roles'])
    if @user.update(user_params)
      flash[:success] = "Your account was updated successfully"
      redirect_to edit_user_path(@user)
    else
      render 'edit'
    end 
  end 

  def show 
  end 

  def destroy
    @user.destroy
      redirect_to users_url, notice: "'#{@user.username}' profile was successfully destroyed."
  end

  private 
  def user_params
    params.require(:user).permit(:username, :email, :password, :points)
  end 

  def set_user
    @user = User.find(params[:id])
  end 

  def require_same_user
    unless current_user == @user && !current_user.admin?
      flash[:danger] = "you can only do this with your own account"
      redirect_to root_path
    end
  end 

end 