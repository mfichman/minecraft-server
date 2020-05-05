class HomeController < ApplicationController
  skip_after_action :verify_authorized

  def index
    redirect_to minecraft_path
  end
end
