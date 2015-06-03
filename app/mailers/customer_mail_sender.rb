require "haml"
require 'haml/template/plugin'

class CustomerMailSender < ApplicationMailer

  def ticket_created_mail(customer, email, reference)
    @customer = customer
    @reference = reference
    mail(to: email, subject: 'Ticket created!')
  end
end
