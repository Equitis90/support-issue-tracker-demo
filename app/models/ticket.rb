class Ticket < ActiveRecord::Base
  has_many :ticket_messages, :inverse_of => :ticket
end
