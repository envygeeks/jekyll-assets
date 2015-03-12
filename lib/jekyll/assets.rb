require "jekyll/assets/patches"
require "jekyll/assets/filters"
require "jekyll/assets/tag"
require "jekyll/assets/version"

module Jekyll
  module Assets
    def self.configure(&block)
      @configure_blocks ||= []
      @configure_blocks << block
    end

    def self.reset_configure
      @configure_blocks = []
    end

    def self.configure_blocks
      @configure_blocks || []
    end
  end
end

Dir[File.dirname(__FILE__) + "/jekyll-assets/*.rb"].each { |file| require file }
