module Minecraft
  class JarsController < RootController
    before_action :set_jars, only: [:index]
    before_action :set_jar, only: [:show, :edit, :update, :destroy]

    def new
      @jar = Jar.new
    end

    def create
      @jar = Jar.new(jar_params)

      if @jar.save
        redirect_to minecraft_path, notice: 'Jar successfully created'
      else
        render :new
      end
    end

    def update
      @jar.assign_attributes(jar_params)

      if @jar.save
        redirect_to minecraft_path, notice: 'Jar successfully updated'
      else
        render :new
      end
    end

    def destroy
      @jar.destroy

      redirect_to minecraft_path
    end

    private

    def jar_params
      params.require(:jar).permit(:version, :url)
    end

    def set_jar
      @jar = Jar.find(params[:id])
    end

    def set_jars
      @jars = Jar.order(version: :desc)
    end
  end
end
