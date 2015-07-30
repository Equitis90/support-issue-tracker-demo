class Ticket < ActiveRecord::Base
  has_many :ticket_messages, :inverse_of => :ticket
  belongs_to :department
  belongs_to :ticket_status

  after_create :assign_reference
  after_create :send_mail, unless: :skip_callbacks

  private
  def assign_reference
    strs = []
    3.times do |i|
      strs[i] = ('A'..'Z').to_a.shuffle[0,3].join
    end
    start_string = "%06d" % self.id
    middle = start_string.length/2
    first_hex = "%02X" % start_string.slice(0, middle)
    last_hex = "%02X" % start_string.slice(middle, start_string.size)
    self.update_column(:title, "#{strs[0]}-#{first_hex}-#{strs[1]}-#{last_hex}-#{strs[2]}")
  end

  def send_mail
    CustomerMailSender.ticket_created_mail(self.creator_name, self.creator_email, self.title).deliver
  end
end
