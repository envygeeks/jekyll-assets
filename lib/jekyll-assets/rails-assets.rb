# rubocop: disable Style/FileName
require "bundler"

Bundler.require(:rails_assets)

if defined? RailsAssets
  Jekyll::Assets.configure do |assets|
    RailsAssets.components.flat_map(&:load_paths).each do |path|
      assets.append_path(path)
    end
  end
end
