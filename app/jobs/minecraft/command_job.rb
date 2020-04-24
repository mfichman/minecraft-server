class Minecraft::CommandJob < ApplicationJob
  def perform(server, command)
    container = Docker::Container.get('minecraft')
    container.attach(stdin: StringIO.new("#{command.text}\n"))
  end
end
