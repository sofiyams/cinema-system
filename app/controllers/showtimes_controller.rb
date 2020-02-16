class ShowtimesController < ApplicationController
  load_and_authorize_resource
  before_action :set_movie
#  before_action :set_showtime, only: [:show, :edit, :update, :destroy]

  # GET /showtimes
  # GET /showtimes.json
  def index
    @showtimes = @movie.showtimes
  end

  # GET /showtimes/new
  def new
    @showtime = @movie.showtimes.new
  end

  # GET /showtimes/1/edit
  def edit
  end

  # POST /showtimes
  # POST /showtimes.json
  def create
    @showtime = @movie.showtimes.new(showtime_params)

    respond_to do |format|
      if @showtime.save
        format.html { redirect_to movie_path(@movie), notice: 'Showtime was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @showtime.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /showtimes/1
  # PATCH/PUT /showtimes/1.json
  def update
    respond_to do |format|
      if @showtime.update(showtime_params)
        format.html { redirect_to movie_path(@movie), notice: 'Showtime was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @showtime.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /showtimes/1
  # DELETE /showtimes/1.json
  def destroy
    @showtime.destroy
    respond_to do |format|
      format.html { redirect_to showtimes_url, notice: 'Showtime was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_showtime
      @showtime = @movie.showtimes.find_by(id: params[:id])
      if @showtime.nil?
        redirect_to @movie
      end 
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def showtime_params
      params.require(:showtime).permit(:date, :time)
    end

    def set_movie
      @movie = Movie.find_by(id: params[:movie_id])
      if @movie.nil?
        redirect_to movies_url
      end 
    end 
end
