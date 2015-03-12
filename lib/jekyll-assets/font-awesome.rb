# rubocop: disable Style/FileName

module Jekyll
  module Assets
    module FontAwesome
      def self.bind
        Jekyll::Assets.configure do |assets|
          gemspec = Gem::Specification.find_by_name "font-awesome-sass"

          %w(fonts stylesheets).each do |asset|
            assets.append_path File.join(gemspec.gem_dir, "assets", asset)
          end
        end
      end
    end
  end
end
