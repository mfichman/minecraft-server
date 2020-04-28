module Minecraft
  class LoadsController < ApplicationController
    def create
      server = Server.find(params[:server_id])
      backup = Backup.find(params[:backup_id])

      LoadJob.set(queue: server.host).perform_later(current_user, server, backup)

      head :ok
    end
  end
end
