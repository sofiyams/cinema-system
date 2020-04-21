class CreateUserWatchlists < ActiveRecord::Migration[5.1]
  def change
    create_table :user_watchlists do |t|
      t.references :user, foreign_key: true
      t.references :movie, foreign_key: true
      
      t.timestamps
    end
  end
end
