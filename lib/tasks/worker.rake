task worker: :environment do
  exec "#{RbConfig.ruby} bin/sidekiq --queue #{Figaro.env.server_name!} --queue default --concurrency 1"
end
