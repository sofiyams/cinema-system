class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]

  # GET /movies
  # GET /movies.json
  def index
    @movies = Movie.all
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
    @movie.user = User.first
    #respond_to do |format|
      if @movie.save
        redirect_to @movie, notice: "'#{@movie.name}' was successfully created."
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movie_params
      params.require(:movie).permit(:name, :description, :actors, :director, :language, :duration, :release_date)
    end
end
