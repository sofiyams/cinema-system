class ChangeMovieDataType < ActiveRecord::Migration[5.1]
  def change
    change_column :movies, :actors, :string
    change_column :movies, :duration, :decimal
  end
end
