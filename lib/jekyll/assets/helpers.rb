# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Helpers
      MIMES = {
        font: %w(
          application/font-woff2
          application/x-font-opentype
          application/vnd.ms-fontobject
          application/x-font-ttf
          application/font-woff
        ),

        img: %w(
          image/bmp
          image/gif
          image/tiff
          image/svg+xml
          image/x-icon
          image/webp
          image/jpeg
          image/png
        )
      }

      # --
      # asset_path will find the path to the asset.
      # @param [String] path the path you wish to resolve.
      # @param [Hash] opts, the opts.
      # @return [String]
      # --
      def asset_path(path, mimes: nil)
        asset = nil

        if mimes && !mimes.empty?
          search = mimes.clone
          while asset.nil? && !search.empty?
            asset = env.find_asset(path, {
              accept: search.pop
            })
          end
        else
          asset = env.manifest.find(path)
          asset = asset.first
        end

        if !asset
          raise Errors::AssetNotFound, path
        end

        env.manifest.compile(path)
        env.uncached.prefix_path(asset.
          digest_path)
      end

      # --
      # @param [Hash] opts the opts
      # @param [String] path the path you wish to resolve
      # Pull the asset path and wrap it in url().
      # @return [String]
      # --
      def asset_url(path, **kwd)
        return "url(#{
          asset_path(path, **kwd)
        })"
      end

      # --
      # Creates:
      # - font_url
      # - font_path
      # - img_path
      # - img_url
      # --
      %W(font img).each do |k|
        mimes = MIMES[k.to_sym]

        define_method("#{k}_path") { |*a| asset_path(*a, mimes: mimes) }
        define_method "#{k}_url" do  |*a|
          asset_url(*a, mimes: mimes)
        end
      end
    end
  end
end

#

module Sprockets
  class Context
    prepend Jekyll::Assets::Helpers
    alias_method :env, :environment
  end
end
