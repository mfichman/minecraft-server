class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
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