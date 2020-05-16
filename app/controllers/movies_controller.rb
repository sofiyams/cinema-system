class MoviesController < ApplicationController
  #before_action :set_movie, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  #before_action :require_user, except: [:index, :show]
  #before_action :require_same_user, only: [:edit, :update, :destroy]

  # GET /movies
  # GET /movies.json
  def index
    # admin users: should see all movies
    if current_user.present? && current_user.admin? 
      @movies = Movie.paginate(page: params[:page], per_page: 5)
      return
    end

    # normal users: should only see movies that are bookable
    # i.e movies with showtimes in the future
    @movies = Movie.bookable.paginate(page: params[:page], per_page: 5)
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(movie_params)
    @movie.user = current_user
    #respond_to do |format|
      if @movie.save
        create_default_ticket_type_for_movie(@movie) if params[:default_ticket_type]
        redirect_to new_movie_showtime_path(@movie), notice: "'#{@movie.name}' was successfully created."
        #render :show, status: :created, location: @movie 
      else
        render action: "new" 
        #format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
   
  end

  # PATCH/PUT /movies/1
  # PATCH/PUT /movies/1.json
  def update
    #respond_to do |format|
      if @movie.update(movie_params)
        redirect_to @movie, notice: "'#{@movie.name}' was successfully updated."
        #format.json { render :show, status: :ok, location: @movie }
      else
        render action: "edit"
        #format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie.destroy
    #respond_to do |format|
      redirect_to movies_url, notice: "'#{@movie.name}' was successfully destroyed."
      #format.json { head :no_content }
  end

  def add_to_watchlist
    watchlist = current_user.user_watchlists
    notice = "Failed to add movie to watchlist, please try again"
    if watchlist.create(movie:@movie)
      notice = "Added successfully to your watchlist"
    end
    redirect_back fallback_location: movie_path(@movie), notice: notice
  end

  def remove_from_watchlist
    watchlist = current_user.user_watchlists
    notice = "Failed to remove movie from your watchlist, please try again"
    if watchlist.where(movie:@movie).destroy_all
      notice = "Removed from your watchlist"
    end
    redirect_back fallback_location: movie_path(@movie), notice: notice
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movie_params
      params.require(:movie).permit(:name, :description, :actors, :director, :language, :duration, :release_date, :default_ticket_type, :image)
    end

    def require_same_user
      if current_user != current_user.admin?
        flash[:danger] = "you can't do this"
        redirect_to movie_path
      end
    end 

    def create_default_ticket_type_for_movie(movie)
      TicketType::DefaultPricing.each {|name, price| TicketType.create(name: name, movie: movie, price: price) }
    end 
end
