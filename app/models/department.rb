class Department < ActiveRecord::Base
  has_many :users
  has_many :tickets, :inverse_of => :department
end
