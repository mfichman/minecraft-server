require_dependency 'socket'

class RunServerCommandJob < ApplicationJob
  def perform(id)
    commmand = ServerCommand.find(id)

    TCPSocket.open('minecraft', 25566) do |socket|
      socket.puts command.text
    end
  end
end
