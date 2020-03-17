class RenameTicketTypes < ActiveRecord::Migration[5.1]
  def change
    rename_column :ticket_types, :type, :name
    rename_column :tickets, :ticket_types_id, :ticket_type_id
  end
end
