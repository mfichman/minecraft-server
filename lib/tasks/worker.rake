task worker: :environment do
  queue = Figaro.env.server_name || 'default'
  exec "#{RbConfig.ruby} bin/sidekiq --queue #{queue} --queue default --concurrency 1"
end
