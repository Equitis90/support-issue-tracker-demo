class AdminController < ApplicationController
  before_filter :check_for_user, :except => [:admin, :log_in_post]
  def check_for_user
    unless session[:user]
      flash[:danger] = 'Administrative area please log in!'
      redirect_to admin_path and return
    end
  end

  def admin
    if session[:user]
      redirect_to tickets_path and return
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
      redirect_to tickets_path and return
    else
      flash[:danger] = 'Wrong login or password!'
      redirect_to admin_path and return
    end
  end

  def log_out_post
    session[:user] = nil
    redirect_to root_path and return
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
        tickets.where(department_id: user.department_id, ticket_status_id: status_id, user_id: user.id).each do |ticket|
          @tickets << {id: ticket.id, reference: ticket.title, department: ticket.department.title, status: ticket.ticket_status.title,
                       creator_name: ticket.creator_name, creator_email: ticket.creator_email}
        end
      else
        tickets.where(department_id: user.department_id, user_id: nil).each do |ticket|
          @tickets << {id: ticket.id, reference: ticket.title, department: ticket.department.title, status: ticket.ticket_status.title,
                       creator_name: ticket.creator_name, creator_email: ticket.creator_email}
        end
      end
    else
      if status_id
        tickets.where(ticket_status_id: status_id, user_id: user.id).each do |ticket|
          @tickets << {id: ticket.id, reference: ticket.title, department: ticket.department.title, status: ticket.ticket_status.title,
                       creator_name: ticket.creator_name, creator_email: ticket.creator_email}
        end
      else
        tickets.where(user_id: nil).each do |ticket|
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
      User.where("login != 'admin' and username != 'admin'").each do |user|
        @users << {id: user.id, username: user.username, login: user.login, admin: user.admin ? 'Yes' : 'No',
                   department: user.department_id.nil? ? 'Without department' : departments[user.department_id]}
      end
    else
      flash[:danger] = 'You do not have permission to visit this page!'
      redirect_to tickets_path and return
    end
  end

  def create_user
    if params[:login].blank? || params[:password].blank? || params[:admin].blank? || params[:username].blank?
      flash[:danger] = "Fill all fields please"
    else
      begin
      if User.where(:login => params[:login]).count == 0
        dept_id = params[:departments].to_i if params[:departments].to_i != 0
        User.create!(:login => params[:login], :password => params[:password], :admin => params[:admin],
                     :username => params[:username], :department_id => dept_id)
      else
        flash[:danger] = 'User with given login allready exists!'
      end
      rescue Exception => e
        flash[:danger] = e
      end
    end

    render nothing: true
  end

  def get_user
    json = nil

    user = User.where(id: params[:id].to_i).first
    if user
      json = Jbuilder.encode do |json|
        json.id user.id
        json.login user.login
        json.username user.username
        json.password user.password
        json.department_id user.department_id
        json.admin user.admin
      end
    else
      flash[:danger] = 'User does not exists!'
    end

    render :text => json
  end

  def edit_user
    user = User.where(id: params[:id].to_i).first
    if user
      begin
        if User.where(:login => params[:login]).where.not(id: params[:id].to_i).count == 0
          dept_id = params[:departments].to_i if params[:departments].to_i != 0
          user.login = params[:login]
          user.password = params[:password]
          user.admin = params[:admin]
          user.username = params[:username]
          user.department_id = dept_id
          user.save!
        else
          flash[:danger] = 'User with given login allready exists!'
        end
      rescue Exception => e
        flash[:danger] = e
      end
    else
      flash[:danger] = 'User does not exists!'
    end

    render nothing: true
  end

  def delete_user
    user = User.where(id: params[:id].to_i).first
    if user
      message = TicketMessage.where(user_id: user.id).first
      if message
        flash[:danger] = 'User can not be deleted it has messages!'
      else
        begin
          user.destroy!
          flash[:success] = 'User deleted!'
        rescue Exception => e
          flash[:danger] = e
        end
      end
    else
      flash[:danger] = 'User does not exists!'
    end

    render nothing: true
  end

  def departments
    user = User.where(id: session[:user]).first
    @user = {id: user.id, username: user.username, department_id: user.department_id, admin: user.admin}
    if user && user.admin
      @departments = []
      Department.all.each do |dep|
        @departments << {id: dep.id, title: dep.title}
      end
    else
      flash[:danger] = 'You do not have permission to visit this page!'
      redirect_to tickets_path and return
    end
  end

  def create_department
    if params[:title].blank?
      flash[:danger] = "Fill title field please"
    else
      begin
        if Department.where(:title => params[:title]).count == 0
          Department.create!(:title => params[:title])
        else
          flash[:danger] = "Department with given title allready exists!"
        end
      rescue Exception => e
        flash[:danger] = e
      end
    end

    render nothing: true
  end

  def get_department
    json = nil

    department = Department.where(id: params[:id].to_i).first
    if department
      json = Jbuilder.encode do |json|
        json.id department.id
        json.title department.title
      end
    else
      flash[:danger] = 'Department does not exists!'
    end

    render :text => json
  end

  def edit_department
    department = Department.where(id: params[:id].to_i).first
    if department
      begin
        if Department.where(:title => params[:title]).where.not(id: params[:id].to_i).count == 0
          department.title = params[:title]
          department.save!
        else
          flash[:danger] = "Department with given title allready exists!"
        end
      rescue Exception => e
        flash[:danger] = e
      end
    else
      flash[:danger] = 'Department does not exists!'
    end

    render nothing: true
  end

  def delete_department
    department = Department.where(id: params[:id].to_i).first
    if department
      user = User.where(department_id: department.id).first
      if user
        flash[:danger] = 'Department can not be deleted it has users!'
      else
        begin
          department.destroy!
          flash[:success] = 'Department deleted!'
        rescue Exception => e
          flash[:danger] = e
        end
      end
    else
      flash[:danger] = 'Department does not exists!'
    end

    render nothing: true
  end

  def ticket_statuses
    user = User.where(id: session[:user]).first
    @user = {id: user.id, username: user.username, department_id: user.department_id, admin: user.admin}
    if user && user.admin
      @ticket_statuses = []
      TicketStatus.all.each do |t_s|
        @ticket_statuses << {id: t_s.id, title: t_s.title}
      end
    else
      flash[:danger] = 'You do not have permission to visit this page!'
      redirect_to tickets_path :page => params[:page] || 1 and return
    end
  end

  def create_ticket_status
    if params[:title].blank?
      flash[:danger] = "Fill title field please"
    else
      begin
        if TicketStatus.where(:title => params[:title]).count == 0
          TicketStatus.create!(:title => params[:title])
        else
          flash[:danger] = "Ticket status with given title allready exists!"
        end
      rescue Exception => e
        flash[:danger] = e
      end
    end

    render nothing: true
  end

  def get_ticket_status
    json = nil

    ticket_status = TicketStatus.where(id: params[:id].to_i).first
    if ticket_status
      json = Jbuilder.encode do |json|
        json.id ticket_status.id
        json.title ticket_status.title
      end
    else
      flash[:danger] = 'Ticket status does not exists!'
    end

    render :text => json
  end

  def edit_ticket_status
    ticket_status = TicketStatus.where(id: params[:id].to_i).first
    if ticket_status
      begin
        if TicketStatus.where(:title => params[:title]).where.not(id: params[:id].to_i).count == 0
          ticket_status.title = params[:title]
          ticket_status.save!
        else
          flash[:danger] = "Ticket status with given title allready exists!"
        end
      rescue Exception => e
        flash[:danger] = e
      end
    else
      flash[:danger] = 'Ticket status does not exists!'
    end

    render nothing: true
  end

  def delete_ticket_status
    ticket_status = TicketStatus.where(id: params[:id].to_i).first
    if ticket_status
      ticket = Ticket.where(ticket_status_id: ticket_status.id).first
      if ticket
        flash[:danger] = 'Ticket status can not be deleted, tickets with this status exists!'
      else
        begin
          ticket_status.destroy!
          flash[:success] = 'Ticket status deleted!'
        rescue Exception => e
          flash[:danger] = e
        end
      end
    else
      flash[:danger] = 'Ticket status does not exists!'
    end

    render nothing: true
  end
end