class MailSender < ApplicationMailer

  def ticket_created_mail(customer, email, reference)
    @customer = customer
    @reference = reference
    mail(to: email, subject: 'Ticket created!')
    format.html { render '' }
  end
end
