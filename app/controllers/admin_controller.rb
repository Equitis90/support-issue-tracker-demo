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
    user = User.where(id: session[:user]).first
    @user = {id: user.id, username: user.username, department_id: user.department_id, admin: user.admin}
    if user.department_id
      Ticket.joins(:department, :ticket_status).where(department_id: user.department_id).each do |ticket|
        @tickets << {id: ticket.id, reference: ticket.title, department: ticket.department.title, status: ticket.ticket_status.title,
                     creator_name: ticket.creator_name, creator_email: ticket.creator_email}
      end
    else
      Ticket.joins(:department, :ticket_status).all.each do |ticket|
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

  def tickets_list_partial
    status_id = params[:id].to_i if params[:id] && params[:id].to_i != 0
    @status_id = status_id
    @tickets = []
    user = User.where(id: session[:user]).first
    @user = {id: user.id, username: user.username, department_id: user.department_id, admin: user.admin}
    tickets = Ticket.joins(:department, :ticket_status)
    if user.department_id
      if status_id
        tickets.where(department_id: user.department_id, ticket_status_id: status_id).each do |ticket|
          @tickets << {id: ticket.id, reference: ticket.title, department: ticket.department.title, status: ticket.ticket_status.title,
                       creator_name: ticket.creator_name, creator_email: ticket.creator_email}
        end
      else
        tickets.where(department_id: user.department_id).each do |ticket|
          @tickets << {id: ticket.id, reference: ticket.title, department: ticket.department.title, status: ticket.ticket_status.title,
                       creator_name: ticket.creator_name, creator_email: ticket.creator_email}
        end
      end
    else
      if status_id
        Ticket.joins(:department, :ticket_status).where(ticket_status_id: status_id).each do |ticket|
          @tickets << {id: ticket.id, reference: ticket.title, department: ticket.department.title, status: ticket.ticket_status.title,
                       creator_name: ticket.creator_name, creator_email: ticket.creator_email}
        end
      else
        Ticket.joins(:department, :ticket_status).all.each do |ticket|
          @tickets << {id: ticket.id, reference: ticket.title, department: ticket.department.title, status: ticket.ticket_status.title,
                       creator_name: ticket.creator_name, creator_email: ticket.creator_email}
        end
      end
    end
    render :layout => false
  end

  def users
    @departments = []
    Department.all.each do |dep|
      @departments << [dep.title, dep.id]
    end
    user = User.where(id: session[:user]).first
    @user = {id: user.id, username: user.username, department_id: user.department_id, admin: user.admin}
    if user && user.admin
      @users = []
      departments = {}
      Department.all.each do |dept|
        departments[dept.id] = dept.title
      end
      User.all.each do |user|
        @users << {id: user.id, username: user.username, login: user.login, admin: user.admin ? 'Yes' : 'No',
                   department: user.department_id.nil? ? 'Without department' : departments[user.department_id]}
      end
    else
      flash[:danger] = 'You do not have permission to visit this page!'
      redirect_to tickets_path
    end
  end

  def create_user
    User.create!(:login => params[:login], :password => params[:password], :admin => params[:admin], :username => params[:username])
    render nothing: true
  end
end