class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :title, :null => false
      t.integer :department_id, :null => false
      t.integer :status, :null => false

      t.timestamps null: false
    end
  end
end
