class HomeController < ApplicationController
  def index
    redirect_to minecraft_path
  end
end
