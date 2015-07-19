require_relative "assets/helpers"
require "sprockets"
require "sprockets/helpers"
require "jekyll"

require_relative "assets/hook"
Dir[File.expand_path("../assets/extras/*.rb", __FILE__)].each do |f|
  require f
end

require_relative "assets/env"
require_relative "assets/whitelist"
require_relative "assets/patches/jekyll/cleaner"
require_relative "assets/patches/sprockets/erb_processor"
require_relative "assets/patches/jekyll/site"

require_relative "assets/hooks/post_read"
require_relative "assets/hooks/post_write"
require_relative "assets/tag"
