namespace :minecraft do
  task logs: :environment do
    server = Minecraft::Server.find_or_create_by!(host: Figaro.env.server_name!)

    time = server.logs.order(:id).last&.created_at

    MinecraftUtils.logs(since: time) do |chunk|
      server.logs.create!(text: chunk)
    end
  end
end
