namespace :minecraft do
  task monitor: :environment do
    server = Minecraft::Server.find_or_create_by!(host: Figaro.env.server_name!)

    loop do
      container = Docker::Container.get('minecraft')
      pid = container.info.dig('State', 'Pid')

      connections = Netstat.filter(path: "/proc/#{pid}/net/tcp", local_port: 25565, state: 'ESTABLISHED')

      if connections.empty?
        server.update!(connections: connections.size)
        IdleJob.perform_later(server) if server.inactive?
      else
        server.update!(connections: connections.size, last_active_at: Time.now.utc)
      end

      sleep 1.minute 

      server.reload
    end
  end
end
