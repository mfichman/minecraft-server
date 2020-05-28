module Minecraft
  class ShutdownsController < RootController
    def create
      server = Server.find(params[:server_id])

      ShutdownJob.perform_now(current_user, server)

      head :ok
    end
  end
end
