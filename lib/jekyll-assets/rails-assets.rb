# rubocop: disable Style/FileName
module Jekyll
  module Assets
    module RailsAssets
      def self.bind
        require "bundler"

        Bundler.require(:rails_assets)

        if defined? RailsAssets
          Jekyll::Assets.configure do |assets|
            RailsAssets.components.flat_map(&:load_paths).each do |path|
              assets.append_path(path)
            end
          end
        end
      end
    end
  end
end
