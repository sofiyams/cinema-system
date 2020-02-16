class CreateBookings < ActiveRecord::Migration[5.1]
  def change
    create_table :bookings do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :movie, foreign_key: true
      t.belongs_to :showtime, foreign_key: true
      
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone_number, null: false
      t.string :title, null: false
      t.timestamps
    end
  end
end
