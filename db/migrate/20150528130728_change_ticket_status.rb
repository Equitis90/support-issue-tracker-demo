class ChangeTicketStatus < ActiveRecord::Migration
  def change
    change_column :tickets, :title, :string, :null => true
  end
end
