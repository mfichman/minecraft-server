module Minecraft
  class ServicesController < Minecraft::RootController
    skip_before_action :authenticate_user!
    skip_before_action :verify_authorization
    skip_after_action :verify_authorized

    def show
      content = YAML.load_file(Rails.root.join('services', "#{params[:id]}.yml"))
      render body: YAML.dump(content['services'])
    end
  end
end
