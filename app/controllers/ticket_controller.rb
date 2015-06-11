class TicketController < ApplicationController
  def index
    if session[:user]
      user = User.where(id: session[:user]).first
      @user = {id: user.id, username: user.username, department_id: user.department_id, admin: user.admin}
    end
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
      redirect_to ticket_path :reference => ticket.title
    else
      flash[:danger] = "Something went wrong!"
      redirect_to root_path and return
    end
  end

  def search_ticket
    ticket = Ticket.where(title: params[:ticket_reference]).first
    if ticket
      redirect_to ticket_path :reference => params[:ticket_reference]
    else
      flash[:danger] = "Ticket with given reference is not exists!"
      redirect_to root_path and return
    end
  end

  def ticket
    if session[:user]
      user = User.where(id: session[:user]).first
      @user = {id: user.id, username: user.username, department_id: user.department_id, admin: user.admin}
    end
    @ticket = Ticket.joins(:ticket_messages).where(title: params[:reference]).first
    @statuses = []
    TicketStatus.all.each do |t_s|
      @statuses << [t_s.title, t_s.id]
    end
  end

  def ticket_add_message_post
    if params[:ticket_message].blank?
      flash[:info] = 'Blank message. Please fill in the field.'
      redirect_to ticket_path :reference => params[:ticket_reference]
    else
      ticket = Ticket.where(title: params[:ticket_reference]).first
      if ticket
        if session[:user]
          if params[:ticket_status].to_i != 0
            begin
              ticket.ticket_status_id = params[:ticket_status].to_i
              ticket.save!
              CustomerMailSender.ticket_change_mail(ticket.creator_name, ticket.creator_email, ticket.title).deliver
            rescue Exception => e
              flash[:danger] = e
              redirect_to ticket_path :reference => params[:ticket_reference] and return
            end
          else
            flash[:danger] = "Something went wrong! Message does not saved!"
            redirect_to ticket_path :reference => params[:ticket_reference] and return
          end
        else
          begin
            wait_for_staff_status = TicketStatus.where(title: 'Waiting for Staff Response').first.try(:id)
            wait_for_customer_status = TicketStatus.where(title: 'Waiting for Customer').first.try(:id)
            if ticket.ticket_status_id == wait_for_customer_status
              ticket.ticket_status_id = wait_for_staff_status
              ticket.save!
            end
          rescue Exception => e
            flash[:danger] = e
            redirect_to ticket_path :reference => params[:ticket_reference] and return
          end
        end
        begin
          message = TicketMessage.new(text: params[:ticket_message], ticket_id: ticket.id)
          message.user_id = session[:user].to_i if session[:user] && session[:user].to_i != 0
          message.save!
        rescue Exception => e
          flash[:danger] = e
          redirect_to ticket_path :reference => params[:ticket_reference] and return
        end
        redirect_to ticket_path :reference => params[:ticket_reference] and return
      else
        flash[:danger] = "Something went wrong! Ticket not found"
        redirect_to root_path and return
      end
    end
  end
end