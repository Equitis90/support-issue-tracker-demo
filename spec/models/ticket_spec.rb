require "rails_helper"

RSpec.describe Ticket, :type => :model do
  let!(:department) { FactoryGirl.create(:department) }
  let!(:ticket_status) { FactoryGirl.create(:ticket_status) }
  let!(:user) { FactoryGirl.build(:user, department_id: department.id) }
  let!(:ticket) { FactoryGirl.build(:ticket, department_id: department.id, ticket_status_id: ticket_status.id) }
  let!(:ticket_message) { FactoryGirl.build(:ticket_message) }

  it "should create ticket" do
    ticket.skip_callbacks = true
    expect { ticket.save }.to change(Ticket, :count)
    ticket_message.ticket_id = ticket.id
    expect { ticket_message.save }.to change(TicketMessage, :count)
    ticket.user_id = user.id
    ticket.save
    expect( ticket.user_id ).to eq(user.id)
  end

end