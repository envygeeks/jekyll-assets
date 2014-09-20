# rubocop: disable Style/FileName
require "sprockets"

gemspec = Gem::Specification.find_by_name "font-awesome-sass"

%w(fonts stylesheets).each do |asset|
  Sprockets.append_path File.join(gemspec.gem_dir, "assets", asset)
end
