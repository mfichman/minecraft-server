module Minecraft
  class Backup < ApplicationRecord
    belongs_to :world

    has_one_attached :file
  end
end
