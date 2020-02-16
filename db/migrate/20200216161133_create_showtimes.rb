class CreateShowtimes < ActiveRecord::Migration[5.1]
  def change
    create_table :showtimes do |t|
      t.references :movie, foreign_key: true
      t.date :date
      t.time :time

      t.timestamps
    end
  end
end
