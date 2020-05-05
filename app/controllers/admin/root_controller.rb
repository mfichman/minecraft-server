module Admin
  class RootController < ApplicationController
    before_action :set_users

    private

    def set_users
      @users = User.order(:email)
    end

    def verify_authorization
      authorize [:admin, :root]
    end
  end
end

