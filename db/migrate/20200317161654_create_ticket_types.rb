class CreateTicketTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :ticket_types do |t|
      t.references :movie, foreign_key: true
      t.string :type
      t.decimal :price

      t.timestamps
    end
  end
end
