class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  class Authenticator < Struct.new(:authentication_handler)
    def authenticate(username)
      user = User.find_by_username(username)
      if user
        authentication_handler.login_successful(user)
      else
        authentication_handler.login_failed(username)
      end
    end
  end

  class SessionStorage < Struct.new(:authentication_handler, :session)
    def login_failed(username)
      authentication_handler.login_failed(username)
    end

    def login_successful(user)
      session[:logged_in_user_id] = user.id
      authentication_handler.login_failed(user)
    end
  end

  def create
    username = params[:user_session][:username]

    Authenticator.new(SessionStorage.new(self, session)).authenticate(username)
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
    redirect_to root_path, status: 303
  end
end
