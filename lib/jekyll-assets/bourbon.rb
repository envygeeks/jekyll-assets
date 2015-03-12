module Jekyll
  module Assets
    module Bourbon
      def self.bind
        Jekyll::Assets.configure do |assets|
          bourbon_root = Gem::Specification.find_by_name("bourbon").gem_dir
          path = File.join(bourbon_root, "app", "assets", "stylesheets")
          assets.append_path path
        end
      end
    end
  end
end
