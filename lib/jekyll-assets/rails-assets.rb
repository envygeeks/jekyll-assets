# rubocop: disable Style/FileName
Bundler.require(:rails_assets)

if defined? RailsAssets
  RailsAssets.components.flat_map(&:load_paths).each do |path|
    Sprockets.append_path(path)
  end
end
