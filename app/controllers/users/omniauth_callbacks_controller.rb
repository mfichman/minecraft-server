class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized

  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user
    else
      redirect_to new_user_session_path
    end
  end

  def failure
    redirect_to new_user_session_path
  end
end
