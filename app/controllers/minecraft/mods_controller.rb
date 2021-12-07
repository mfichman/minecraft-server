module Minecraft
  class ModsController < RootController
    before_action :set_mods, only: [:index]
    before_action :set_mod, only: [:show, :edit, :update, :destroy]

    def new
      @mod = Mod.new
    end

    def create
      @mod = Mod.new(mod_params)

      if @mod.save
        redirect_to minecraft_path, notice: 'Mod successfully created'
      else
        render :new
      end
    end

    def update
      @mod.assign_attributes(mod_params)

      if @mod.save
        redirect_to minecraft_path, notice: 'Mod successfully updated'
      else
        render :new
      end
    end

    def destroy
      @mod.destroy

      redirect_to minecraft_path
    end

    private

    def mod_params
      params.require(:mod).permit(:name, :version, :url)
    end

    def set_mod
      @mod = Mod.find(params[:id])
    end

    def set_mods
      @mods = Mod.order(:name, version: :desc)
    end
  end
end
