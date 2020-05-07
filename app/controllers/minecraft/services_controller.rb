module Minecraft
  class ServicesController < Minecraft::RootController
    skip_before_action :authenticate_user!
    skip_after_action :verify_authorized

    prepend_view_path Rails.root.join('services')

    def show
      render file: "#{params[:id]}.yml"
    end
  end
end
