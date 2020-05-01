module Minecraft
  class WorldsController < ApplicationController
    before_action :set_worlds, only: [:index]
    before_action :set_world, only: [:show, :edit, :update]

    def new
      @world = World.new
      @backup = @world.backups.build
    end

    def create
      @world = World.new(world_params)

      if @world.save
        redirect_to minecraft_worlds_path
      else
        render :new
      end
    end

    def destroy
      @world.destroy
    end

    private

    def world_params
      params.require(:world).permit(:name, backups_attributes: [:file])
    end

    def set_world
      @world = World.find(params[:id])
    end

    def set_worlds
      @worlds = World.all
    end
  end
end
