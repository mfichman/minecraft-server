namespace :minecraft do
  task logger: :environment do
    server = Minecraft::Server.find_or_create_by!(host: Figaro.env.server_name!)

    loop do
      connections = Netstat.filter(local_port: 19132, state: 'ESTABLISHED')

      if connections.empty?
        server.update!(connections: connections.size)
        ShutdownJob.perform_now(server) if server.inactive?
      else
        server.update!(connections: connections.size, last_active_at: Time.now.utc)
      end

      sleep 1.minute 
    end
  end
end
