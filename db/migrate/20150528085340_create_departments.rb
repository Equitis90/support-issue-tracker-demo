class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :title

      t.timestamps null: false
    end
    Department.create!(title: 'General issues')
  end
end
