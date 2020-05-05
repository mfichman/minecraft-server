module Minecraft
  class WorldsController < RootController
    before_action :set_worlds, only: [:index]
    before_action :set_world, only: [:show, :edit, :update, :destroy]

    def new
      @world = World.new
      @backup = @world.backups.build
    end

    def create
      @world = World.new(world_params)

      if @world.save
        redirect_to minecraft_path
      else
        render :new
      end
    end

    def update
      @world.assign_attributes(world_params)

      if @world.save
        redirect_to minecraft_path
      else
        render :new
      end
    end

    def destroy
      @world.destroy

      redirect_to minecraft_path
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
