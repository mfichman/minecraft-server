module Admin
  class UsersController < RootController
    before_action :set_users, only: [:index]
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :set_backups, only: [:show]

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)

      if @user.save
        redirect_to admin_path, notice: 'User successfully created'
      else
        render :new
      end
    end

    def update
      @user.assign_attributes(user_params)

      if @user.save
        redirect_to admin_path, notice: 'User successfully updated'
      else
        render :new
      end
    end

    def destroy
      @user.destroy

      redirect_to admin_path
    end

    private

    def user_params
      params.require(:user).permit(:email, :confirmed)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def set_users
      @users = User.order(:host)
    end
  end
end

