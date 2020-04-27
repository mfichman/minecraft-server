module Minecraft
  class LogsChannel < ApplicationCable::Channel
    def subscribed
      server = Server.find(params[:server_id])
      stream_for server
    end
  end
end
