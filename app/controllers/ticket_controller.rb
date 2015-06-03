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

  def search_ticket
    ticket = Ticket.where(title: params[:ticket_reference]).first
    if ticket
      redirect_to ticket_path :reference => params[:ticket_reference]
    else
      flash[:danger] = "Ticket with given reference is not exists!"
      redirect_to root_path
    end
  end

  def ticket
    @ticket = Ticket.joins(:ticket_messages).where(title: params[:reference]).first
  end

  def ticket_add_message_post
    if params[:ticket_message].blank?
      flash[:info] = 'Blank message. Please fill in the field.'
      redirect_to ticket_path :reference => params[:ticket_reference]
    else
      ticket = Ticket.where(title: params[:ticket_reference]).first
      if ticket
        message = TicketMessage.new(text: params[:ticket_message], ticket_id: ticket.id)
        message.user_id = session[:user].id if session[:user]
        message.save!
        redirect_to ticket_path :reference => params[:ticket_reference]
      else
        flash[:danger] = "Something went wrong! Ticket not found"
        redirect_to root_path
      end
    end
  end
end