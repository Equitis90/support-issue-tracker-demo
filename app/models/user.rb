class User < ActiveRecord::Base
  has_one :department
  attr_encrypted :password, :key => 'Secret key!!'

  def self.current=(user)
    @current_user = user
  end

  def self.current
    @current_user
  end
end
