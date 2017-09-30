# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "fastimage"

module Jekyll
  module Assets
    module Liquid
      class Tag < ::Liquid::Tag
        attr_reader :args

        # --
        # Liquid doesn't like to make it's new method public
        # so we go back and make it public so that we can ship
        # this tag from within filters.
        # --
        class << self
          public :new
        end

        # --
        class AssetNotFoundError < StandardError
          def initialize(asset)
            super "Could not find the asset `#{asset}'"
          end
        end

        # --
        SUPPORTED = %W(
          img
          image
          javascript
          asset_source
          stylesheet
          asset_path
          style
          asset
          css
          js
        ).freeze

        # --
        HTML = {
          "css" => %(<link type="text/css" rel="stylesheet" href="%s"%s>),
          "js"  => %(<script type="text/javascript" src="%s"%s></script>),
          "img" => %(<img src="%s"%s>)
        }.freeze

        # --
        ALIASES = {
          "image" => "img",
          "stylesheet" => "css",
          "javascript" => "js",
          "style" => "css"
        }.freeze

        # --
        def initialize(tag, args, tokens)
          tag = tag.to_s
          @tokens = tokens
          @tag = from_alias(tag)
          @args = Liquid::Tag::Parser.new(args).args
          @og_tag = tag
          super
        end

        # --
        def render(context)
          site = context.registers[:site]
          page = context.registers[:page] ||= {}
          sprockets = site.sprockets
          page = page["path"]
          # Process.
        rescue => e
          capture_and_out_error(site, e)
        end

        # --
        # @param [String] tag the original tag.
        # from_alias will extract a tags alias to it's expected
        # tag... so that people can stay consistent and minimal with
        # what they have to put inside of their FOR stuff.
        # @return [String] the tag.
        # --
        private
        def from_alias(tag)
          ALIASES.key?(tag) ? ALIASES[tag] : tag
        end

        # --
        # @param [Jekyll::Site] site the Jekyll site.
        # @param [Error] error the Ruby error wrapper.
        # capture_and_out_error captures an error, reports it
        # through Jekyll and then ships the error again through us.
        # It also wraps around SASS so you get a valid error.
        # @raise the original error.
        # @return [nil]
        # --
        private
        def capture_and_out_error(site, error)
          if error.is_a?(Sass::SyntaxError)
            file = error.sass_filename
            file = file.gsub(/#{Regexp.escape(site.source)}\//, "")
            str = "Error #{file}:#{error.sass_line}" \
              "#{error}"
          else
            str = error.to_s
          end

          Jekyll.logger.error("", str)
          raise error
        end
      end
    end
  end
end

# --

Jekyll::Assets::Liquid::Tag::SUPPORTED.each do |v|
  Liquid::Template.register_tag v, Jekyll::Assets::Liquid::Tag
end
