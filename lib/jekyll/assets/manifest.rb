# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "sprockets/manifest"

module Jekyll
  module Assets
    class Manifest < Sprockets::Manifest
      attr_reader :data

      # --
      # Works around some weird behavior in Sprockets 3.x that seemd to make
      # it so that when you use an absolute path, it was automatically a filter
      # and so you could never find an asset that was dynamically added.
      # --
      def self.simple_logical_path?(file)
        super || File.file?(file)
      end

      # --
      # Allows you to add a manifest key for us to keep.
      # @note the format should be `key: { hashKey: hashVal }` or `key: []`
      # @note complex keys aren't supported.
      # @return [Array<String>]
      # --
      def self.keep_keys
        @keep_keys ||= %w(
          assets
        )
      end
    end
  end
end
