module Minecraft
  class CommandJob < ApplicationJob
    def perform(server, command)
      container = Docker::Container.get('minecraft')
      container.attach(stdin: StringIO.new("#{command}\n"))

      nil
    end
  end
end
