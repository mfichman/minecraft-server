namespace :cert do
  task :decrypt do
    server_name = Figaro.env.server_name!

    unless File.exists?('config/key.pem')
      File.write('config/key.pem', Rails.application.credentials.dig(:ssl, server_name.to_sym, :key))
    end

    unless File.exists?('config/cert.pem')
      File.write('config/cert.pem', Rails.application.credentials.dig(:ssl, server_name.to_sym, :cert))
    end
  end
end
