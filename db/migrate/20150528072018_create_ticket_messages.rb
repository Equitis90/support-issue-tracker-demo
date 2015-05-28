class CreateTicketMessages < ActiveRecord::Migration
  def change
    create_table :ticket_messages do |t|
      t.integer :user_id
      t.integer :ticket_id, :null => false
      t.text :text, :null => false

      t.timestamps null: false
    end
  end
end
