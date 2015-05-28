class CreateAdmin < ActiveRecord::Migration
  def change
    User.create!(:login => "admin", :password => '123', :admin => true, :username => 'admin')
  end
end
