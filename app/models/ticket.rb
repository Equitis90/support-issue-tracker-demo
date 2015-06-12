class Ticket < ActiveRecord::Base
  has_many :ticket_messages, :inverse_of => :ticket
  belongs_to :department
  belongs_to :ticket_status

  after_create :assign_reference
  after_create :send_mail, unless: :skip_callbacks

  private
  def assign_reference
    self.update_column(:title, "STR-%06d" % self.id)
  end

  def send_mail
    CustomerMailSender.ticket_created_mail(self.creator_name, self.creator_email, self.title).deliver
  end
end
