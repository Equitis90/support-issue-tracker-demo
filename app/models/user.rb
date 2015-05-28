class User < ActiveRecord::Base
  attr_encrypted :password, :key => 'Secret key!!', :mode => :per_attribute_iv_and_salt
end
