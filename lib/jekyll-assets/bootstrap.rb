module Jekyll
  module Assets
    module Bootstrap
      def self.bind
        gemspec = Gem::Specification.find_by_name "bootstrap-sass"

        Jekyll::Assets.configure do |assets|
          %w(images fonts javascripts stylesheets).each do |asset|
            assets.append_path File.join(gemspec.gem_dir, "assets", asset)
          end
        end
      end
    end
  end
end
