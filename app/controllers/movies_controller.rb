class MoviesController < ApplicationController
  SORTABLE_COLUMNS = %w[title rating release_date].freeze
  SORT_DIRECTIONS = %w[asc desc].freeze

  before_action :set_movie, only: %i[ show edit update destroy ]

  # GET /movies or /movies.json
  def index
    @sort_column = params[:sort].presence
    @sort_column = session[:movies_sort] unless SORTABLE_COLUMNS.include?(@sort_column)
    @sort_column = "title" unless SORTABLE_COLUMNS.include?(@sort_column)

    @sort_direction = params[:direction].presence
    @sort_direction = session[:movies_sort_direction] unless SORT_DIRECTIONS.include?(@sort_direction)
    @sort_direction = "asc" unless SORT_DIRECTIONS.include?(@sort_direction)

    session[:movies_sort] = @sort_column
    session[:movies_sort_direction] = @sort_direction
    @sort_column_index = SORTABLE_COLUMNS.index(@sort_column) + 1
    @movies = Movie.order(@sort_column => @sort_direction.to_sym)
  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @movie.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: "Movie was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @movie.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy!

    respond_to do |format|
      format.html { redirect_to movies_path, notice: "Movie was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.expect(movie: [ :title, :rating, :description, :release_date ])
    end
end
