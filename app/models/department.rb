class Department < ActiveRecord::Base
  has_many :users, :inverse_of => :department
  has_many :tickets, :inverse_of => :department
end
