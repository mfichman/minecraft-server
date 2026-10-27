module Minecraft
  class ReloadJob < ApplicationJob
    def perform(user, server)
      return unless server.world.present?

      SaveJob.perform_now(user, server)

      ToastsChannel.broadcast_to(user, ReloadsController.render(partial: 'info'))
      server.logs.create!(text: "[Controller] Reloading\n")

      data_dir = Figaro.env.minecraft_data || '/minecraft/data'
      install_args = server.slice(:mods, :jar, :modder, :properties, :ops).symbolize_keys
      Minecraft::Utils.reload(data_dir, **install_args)

      ToastsChannel.broadcast_to(user, ReloadsController.render(partial: 'success'))
      server.logs.create!(text: "[Controller] Reloaded\n")
    rescue StandardError => e
      ToastsChannel.broadcast_to(user, ReloadsController.render(partial: 'error', locals: { message: e.message }))
      server.logs.create!(text: "[Controller] Reload error: #{e.message}\n")
      raise
    end
  end
end
