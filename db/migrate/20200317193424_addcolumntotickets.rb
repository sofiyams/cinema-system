class Addcolumntotickets < ActiveRecord::Migration[5.1]
  def change
    add_column :tickets, :seat_num, :string
  end
end
