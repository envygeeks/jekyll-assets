require "jekyll/assets/patches"
require "jekyll/assets/filters"
require "jekyll/assets/tag"
require "jekyll/assets/version"

module Jekyll
  module Assets
    HOOKS = []

    def self.configure(&blk)
      HOOKS << blk
    end
  end
end
