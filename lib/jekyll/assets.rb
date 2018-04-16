# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

require "pathutil"
require "jekyll/assets/version"
require "forwardable/extended"
require "jekyll/sanity"
require "sprockets"
require "jekyll"

module Jekyll
  module Assets
    autoload :Url, "jekyll/assets/url"
    autoload :Drop, "jekyll/assets/drop"
    autoload :Utils, "jekyll/assets/utils"
    autoload :Config, "jekyll/assets/config"
    autoload :Filters, "jekyll/assets/filters"
    autoload :Extensible, "jekyll/assets/extensible"
    autoload :Manifest, "jekyll/assets/manifest"
    autoload :Default, "jekyll/assets/default"
    autoload :Errors, "jekyll/assets/errors"
    autoload :Logger, "jekyll/assets/logger"
    autoload :Proxy, "jekyll/assets/proxy"
    autoload :HTML, "jekyll/assets/html"
    autoload :Hook, "jekyll/assets/hook"
    autoload :Env, "jekyll/assets/env"
    autoload :Tag, "jekyll/assets/tag"

    # --
    # Setup Jekyll Assets
    # @see require_patches!
    # @see before_hook!
    # @see after_hook!
    # @return [nil]
    # --
    def self.setup!
      require_patches!
      %i(read write).each do |v|
        send(:"#{v}_hook!")
      end
    end

    # --
    # Require all our patches
    # @return [nil]
    # --
    def self.require_patches!
      dir = Pathutil.new(__dir__).join("assets", "patches")
      dir.children do |v|
        unless v.directory?
          require v
        end
      end
    end

    # --
    # Initialize the environment
    # @note this happens after Jekyll read
    # @return [nil]
    # --
    def self.read_hook!
      Jekyll::Hooks.register :site, :post_read, priority: 99 do |o|
        unless o.sprockets
          Env.new(o)
        end
      end
    end

    # --
    # Write all the assets
    # @note this happens after Jekyll write
    # @return [nil]
    # --
    def self.write_hook!
      Jekyll::Hooks.register :site, :post_write, priority: 99 do |o|
        o&.sprockets&.write_all
      end
    end

    # --
    private_class_method :write_hook!
    private_class_method :require_patches!
    private_class_method :read_hook!

    # --
    setup!
    Filters.register
    Tag.register
  end
end
