require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MinecraftServer
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.active_job.queue_adapter = :sidekiq

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Eastern Time (US & Canada)"
    config.eager_load_paths << Rails.root.join('app', 'validators')
    config.eager_load_paths << Rails.root.join('app', 'types')
    config.eager_load_paths << Rails.root.join('app', 'policies')
    config.eager_load_paths << Rails.root.join('lib')
  end
end
