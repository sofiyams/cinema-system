class AddImgUrlToMovies < ActiveRecord::Migration[5.1]
  def change
    add_column :movies, :img_url, :string
  end
end
