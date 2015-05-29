class User < ActiveRecord::Base
  has_one :department
  attr_encrypted :password, :key => 'Secret key!!', :mode => :per_attribute_iv_and_salt

  def self.current=(user)
    @current_user = user
  end

  def self.current
    @current_user
  end
end
