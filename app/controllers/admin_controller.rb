class AdminController < ApplicationController
  before_filter :check_for_user, :except => [:admin, :log_in_post]
  def check_for_user
    unless session[:user]
      flash[:danger] = 'Administrative area please log in!'
      redirect_to admin_path
    end
  end

  def admin
    if session[:user]
      redirect_to tickets_path
    end
  end

  def tickets
    @tickets = []
    @active_tab = 0
    status_id = 0
    status_id = params[:id].gsub('#', '').to_i if params[:id] && params[:id] != '#all'
    user = User.where(id: session[:user]).first
    @user = {id: user.id, username: user.username, department_id: user.department_id}
    if user.department_id
      tickets = nil
      if status_id != 0
        tickets = Ticket.joins(:department, :ticket_status).where(department_id: user.department_id, ticket_status_id: status_id)
        @active_tab = status_id
      else
        tickets = Ticket.joins(:department, :ticket_status).where(department_id: user.department_id)
      end
      tickets.each do |ticket|
        @tickets << {id: ticket.id, reference: ticket.title, department: ticket.department.title, status: ticket.ticket_status.title,
                     creator_name: ticket.creator_name, creator_email: ticket.creator_email}
      end
    else
      tickets = nil
      if status_id != 0
        tickets = Ticket.joins(:department, :ticket_status).where(ticket_status_id: status_id)
        @active_tab = status_id
      else
        tickets = Ticket.joins(:department, :ticket_status).all
      end
      tickets.each do |ticket|
        @tickets << {id: ticket.id, reference: ticket.title, department: ticket.department.title, status: ticket.ticket_status.title,
                     creator_name: ticket.creator_name, creator_email: ticket.creator_email}
      end
    end
  end

  def log_in_post
    user = User.where(login: params[:login], encrypted_password: User.encrypt_password(params[:password])).first
    if user
      session[:user] = user.id
      redirect_to tickets_path
    else
      flash[:danger] = 'Wrong login or password!'
      redirect_to admin_path
    end
  end

  def log_out_post
    session[:user] = nil
    redirect_to root_path
  end
end