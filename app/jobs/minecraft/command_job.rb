module Minecraft
  class CommandJob < ApplicationJob
    def perform(server, command)
      response = Minecraft::Utils.run(command)
      server.logs.create!(text: response)
    end
  end
end
