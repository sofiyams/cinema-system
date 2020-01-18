class CreateMovies < ActiveRecord::Migration[5.1]
  def change
    create_table :movies do |t|
      t.string :name
      t.text :description
      t.text :actors
      t.string :director
      t.string :language
      t.integer :duration
      t.date :release_date

      t.timestamps
    end
  end
end
