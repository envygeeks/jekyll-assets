module Jekyll
  module Assets
    module Neat
      def self.bind
        Jekyll::Assets::Bourbon.bind

        Jekyll::Assets.configure do |assets|
          neat_root = Gem::Specification.find_by_name("neat").gem_dir
          path = File.join(neat_root, "app", "assets", "stylesheets")
          assets.append_path path
        end
      end
    end
  end
end
