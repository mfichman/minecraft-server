module Minecraft
  class Backup < ApplicationRecord
    belongs_to :world
    belongs_to :parent, optional: true, class_name: 'Backup'

    has_one_attached :file
  end
end
