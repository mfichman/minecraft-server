module Minecraft
  class ModdersController < RootController
    before_action :set_modders, only: [:index]
    before_action :set_modder, only: [:show, :edit, :update, :destroy]

    def new
      @modder = Modder.new
    end

    def create
      @modder = Modder.new(modder_params)

      if @modder.save
        redirect_to minecraft_path, notice: 'Modder successfully created'
      else
        render :new
      end
    end

    def update
      @modder.assign_attributes(modder_params)

      if @modder.save
        redirect_to minecraft_path, notice: 'Modder successfully updated'
      else
        render :new
      end
    end

    def destroy
      @modder.destroy

      redirect_to minecraft_path
    end

    private

    def modder_params
      params.require(:modder).permit(:name, :version, :url)
    end

    def set_modder
      @modder = Modder.find(params[:id])
    end

    def set_modders
      @modders = Modder.order(:name, version: :desc)
    end
  end
end
