class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  class Authenticator < Struct.new(:controller)
    def authenticate(username)
      user = User.find_by_username(username)
      if user
        controller.login_successful(user)
      else
        controller.login_failed(username)
      end
    end
  end

  def create
    username = params[:user_session][:username]

    Authenticator.new(self).authenticate(username)
  end

  def destroy
    session[:logged_in_user_id] = nil
    redirect_to root_path
  end

  def login_failed(username)
    flash[:error] = "No user with username '#{username}'"
    redirect_to root_path, status: 303
  end

  def login_successful(user)
    session[:logged_in_user_id] = user.id
    redirect_to root_path, status: 303
  end
end
