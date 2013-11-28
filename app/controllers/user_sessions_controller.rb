class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  def create
    username = params[:user_session][:username]

    user = authenticate(username)
    if user
      login_successful(user)
    else
      login_failed(username)
    end

    redirect_to root_path, status: 303
  end

  def destroy
    session[:logged_in_user_id] = nil
    redirect_to root_path
  end

  protected

  def authenticate(username)
    User.find_by_username(username)
  end

  def login_failed(username)
    flash[:error] = "No user with username '#{username}'"
  end

  def login_successful(user)
    session[:logged_in_user_id] = user.id
  end
end
