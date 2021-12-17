namespace :minecraft do
  task monitor: :environment do
    server = Minecraft::Server.find_or_create_by!(host: Figaro.env.server_name!)
    server.update!(last_active_at: Time.now.utc)

    loop do
      connections = Netstat.filter(path: "/proc/net/tcp", local_port: 25565, state: 'ESTABLISHED')

      if connections.empty?
        server.update!(connections: connections.size)
        Minecraft::IdleJob.set(queue: server.host).perform_later(server) if server.inactive?
      else
        server.update!(connections: connections.size, last_active_at: Time.now.utc)
      end

      sleep 1.minute 

      server.reload
    end
  end
end
