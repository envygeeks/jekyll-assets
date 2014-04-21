require "sprockets"

bootstrap = Gem::Specification.find_by_name("bootstrap-sass").gem_dir
%w[fonts javascripts stylesheets].each do |asset|
  Sprockets.append_path File.join(bootstrap, "vendor", "assets", asset)
end
