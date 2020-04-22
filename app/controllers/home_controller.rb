class HomeController < ApplicationController
  def index
    redirect_to servers_path
  end
end
