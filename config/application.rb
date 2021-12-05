require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
#require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MinecraftServer
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    #config.active_job.queue_adapter = :sucker_punch
    config.active_job.queue_adapter = :sidekiq

    # Disable sprockets
    config.assets.enabled = false

    config.eager_load_paths << Rails.root.join('app', 'validators')
    config.eager_load_paths << Rails.root.join('app', 'types')
    config.eager_load_paths << Rails.root.join('app', 'policies')
    config.eager_load_paths << Rails.root.join('lib')

    config.action_controller.default_url_options = {
      host: Figaro.env.host_name || 'mfichman-minecraft.herokuapp.com',
      protocol: 'https',
    }
  end
end
