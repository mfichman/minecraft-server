task web: ['db:migrate'] do
  exec "#{RbConfig.ruby} bin/puma -C config/puma.rb --pidfile puma.pid"
end
