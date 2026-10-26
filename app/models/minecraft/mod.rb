require 'pathname'

class Minecraft::Mod < ApplicationRecord
  validates :name, presence: true, uniqueness: {scope: :version}
  validates :version, presence: true
  validates :url, presence: true, url: true
  validates :path, presence: true
  validate :relative_install_path

  def to_s
    [name, version].join(' ')
  end

  def file_name
    "#{name.parameterize}-#{version.underscore}.jar"
  end

  private

  def relative_install_path
    return if path.blank?

    if Pathname.new(path).absolute? || path.split(/[\\\/]/).include?('..')
      errors.add(:path, 'must be a relative directory without parent traversal')
    end
  end
end
