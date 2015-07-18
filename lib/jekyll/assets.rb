require_relative "assets/helpers/javascript"
require "sprockets"
require "sprockets/helpers"
require "jekyll"

Jekyll::Assets::Helpers::JavaScript.has_javascript? do
  require "sprockets/es6"
  require "autoprefixer-rails"
end

require_relative "assets/patches/jekyll/cleaner"
require_relative "assets/patches/sprockets/erb_processor"
require_relative "assets/patches/jekyll/site"

require_relative "assets/hooks/post_read"
require_relative "assets/hooks/post_write"
require_relative "assets/tag"
