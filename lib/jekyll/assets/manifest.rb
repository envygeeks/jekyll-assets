# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "sprockets/manifest"

module Jekyll
  module Assets
    class Manifest < Sprockets::Manifest
      attr_reader :data

      # --
      # Determines if we've a new manifest file.
      # @note it helps us keep the cache directory clean.
      # rubocop:disable Style/RedundantReturn
      # @return [true, false]
      # --
      def new_manifest?
        return @new_manifest
      end

      # --
      # Set @new_manifest to false by default.
      # @override Sprockets::Manifest#initialize
      # @return See upstream.
      # --
      def initialize(*args)
        @new_manifest = false
        super
      end

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

      # --
      # rubocop:disable Metrics/LineLength
      # Allows us to discover the manifest path, but know
      #   if it's new.
      # --
      def find_directory_manifest(dirname)
        entries = File.directory?(dirname) ? Dir.entries(dirname) : []
        entry = (f = entries.find { |e| e =~ MANIFEST_RE }) || generate_manifest_path
        f || @new_manifest = true
        File.join(dirname, entry)
      end
    end
  end
end
