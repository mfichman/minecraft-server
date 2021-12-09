Sidekiq.default_worker_options = { retry: 0 }

Sidekiq.configure_server do |config|
  config.redis = {ssl_params: {verify_mode: OpenSSL::SSL::VERIFY_NONE}}
end

Sidekiq.configure_client do |config|
  config.redis = {ssl_params: {verify_mode: OpenSSL::SSL::VERIFY_NONE}}
end
