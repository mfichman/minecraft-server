module Minecraft
  class BackupsController < RootController
    before_action :set_backups, only: [:index]

    def create
      @backup = Backup.new(backup_params)

      if @backup.save
        render json: {}, status: :ok
      else
        render json: { errors: @backup.errors.full_messages }, status: :bad_request
      end
    end

    private

    def backup_params
      params.require(:backup).permit(:world_id, :world_name, :server_id)
    end

    def set_backups
      @backups = @server.backups
    end
  end
end
