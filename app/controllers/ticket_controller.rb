class TicketController < ApplicationController
  def index
    @departments = []
    Department.all.each do |dep|
      @departments << [dep.title, dep.id]
    end
  end

  def create_ticket_post
    wait_for_staff_status = TicketStatus.where(title: 'Waiting for Staff Response').first.try(:id)
    ticket = Ticket.create!(department_id: params[:departments], ticket_status_id: wait_for_staff_status,
                            creator_name: params[:name], creator_email: params[:email])
    if ticket
      TicketMessage.create!(ticket_id: ticket.id, text: params[:text])
    end
    redirect_to root_path
  end
end