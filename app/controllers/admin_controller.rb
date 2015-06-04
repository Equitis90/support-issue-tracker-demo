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
      redirect_to user_path
    end
  end

  def user
    @user = User.where(id: session[:user]).first
  end

  def log_in_post
    user = User.where(login: params[:login], encrypted_password: User.encrypt_password(params[:password])).first
    if user
      session[:user] = user.id
      redirect_to user_path
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