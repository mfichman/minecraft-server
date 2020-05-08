module Minecraft
  class BootsController < RootController
    def create
      server = Server.find(params[:server_id])

      BootJob.perform_now(current_user, server)

      head :ok
    end
  end
end
