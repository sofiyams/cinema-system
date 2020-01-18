json.extract! movie, :id, :name, :description, :actors, :director, :language, :duration, :release_date, :created_at, :updated_at
json.url movie_url(movie, format: :json)
