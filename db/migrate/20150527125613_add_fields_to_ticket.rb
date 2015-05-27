class AddFieldsToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :creator_name, :string, :null => false
    add_column :tickets, :creator_email, :string, :null => false
  end
end
