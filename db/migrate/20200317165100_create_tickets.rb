class CreateTickets < ActiveRecord::Migration[5.1]
  def change
    create_table :tickets do |t|
      t.references :booking, foreign_key: true
      t.references :ticket_types, foreign_key: true

      t.timestamps
    end
  end
end
