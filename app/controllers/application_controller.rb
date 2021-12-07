class ApplicationController < ActionController::Base
  include Pundit

  before_action :authenticate_user!
  before_action :verify_authorization
  #before_action :console

  after_action :verify_authorized

  rescue_from Pundit::NotAuthorizedError, with: :flash_not_authorized

  add_flash_types :error, :warning, :success, :info

  def new_session_path(scope)
    new_user_session_path
  end

  def verify_authorization
  end

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to new_user_session_path
    end
  end

  def flash_not_authorized
    redirect_back fallback_location: root_path, error: <<-MSG
      You are not authorized to perform this action. Try asking
      someone for access, ya turkey
    MSG
  end
end
