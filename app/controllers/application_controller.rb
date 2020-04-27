class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  #before_action :console

  def new_session_path(scope)
    new_user_session_path
  end
end
