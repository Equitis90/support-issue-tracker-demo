class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login, :null => false
      t.string :encrypted_password
      t.string :encrypted_password_salt
      t.string :encrypted_password_iv
      t.string :username, :null => false, :default => ''
      t.integer :department_id
      t.boolean :admin, :default => false

      t.timestamps null: false
    end
  end
end
