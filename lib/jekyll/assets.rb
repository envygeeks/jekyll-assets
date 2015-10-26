require "sprockets"
require "jekyll"

Dir.glob(File.expand_path("hooks/*.rb", __dir__)).map do |file|
  require file
end

module Jekyll
  module Assets
    %W(patches/**/* cached config env hook logger version liquid/*
         hooks/* addons/{*,**/*}).each do |path|
      if path !~ /\*/
        require_relative "assets/#{path}"
      else
        Dir.glob(File.expand_path("assets/#{path}.rb", __dir__)). \
            map do |file|
          require file
        end
      end
    end
  end
end
