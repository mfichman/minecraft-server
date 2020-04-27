module Minecraft
  class LoadsController < ApplicationController
    def create
      server = Server.find(params[:server_id])
      backup = Backup.find(params[:backup_id])

      LoadJob.perform_async(current_user, server, backup)

      head :ok
    end
  end
end
