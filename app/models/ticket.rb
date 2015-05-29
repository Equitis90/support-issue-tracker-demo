class Ticket < ActiveRecord::Base
  has_many :ticket_messages, :inverse_of => :ticket

  after_create :assign_reference, :send_mail

  private
  def assign_reference
    self.update_column(:title, "STR-%06d" % self.id)
  end

  def send_mail
    MailSender.ticket_created_mail(self.creator_name, self.creator_email, self.title).deliver
  end
end
