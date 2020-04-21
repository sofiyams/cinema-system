class RemoveImgUrlFromMovies < ActiveRecord::Migration[5.1]
  def change
    remove_column :movies, :img_url, :string
    remove_column :movies, :image_file_name, :string
    remove_column :movies, :image_content_type, :string
    remove_column :movies, :image_file_size, :integer
    remove_column :movies, :image_updated_at, :datetime
  end
end
