module Minecraft
  class IdleJob < ApplicationJob
    def perform(server)
      server.logs.create!(text: "[Controller] Server is idle\n")

      SaveJob.perform_now(nil, server)
      ShutdownJob.perform_now(nil, server) 
    end
  end
end
