# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    class Proxy
      def self.inherited(kls)
        @subs ||= []
        @subs << kls
      end

      # --
      # find_all will find all the proxies.
      # @param [String] for_ the tag to search for
      # @return [Array]
      # --
      def find_all(for_)
        @subs.select do |v|
          v::FOR.include?(for_)
        end
      end

      # --
      # @param [Proxy<>] proxies, the proxies to run
      # run will run all the proxies you ship arguments.
      # @return [nil]
      # --
      def run(proxies, asset:, args:)
        file = temp_path
        proxies.each do |v|
          v.new(asset, args: args, temp_path: file)
        end
      end

      # --
      # @note this is literally temporary.
      # temp_path creates a tempfile to store data in.
      # @return [Pathutil]
      # --
      def temp_path
        Pathutil.tmpfile.tap do |f|
          f.rm
        end
      end

      # --
      def initialize(asset, args:, temp_path: self.temp_path)
        @args = args
        @env = asset.env
        @jekyll = asset.env.jekyll
        @temp_path = temp_path
        @asset = asset
      end

      # --
      def copy_asset
        unless @temp_path.exist?
          Pathutil.new(@asset.filepath).cp(@temp_path)
        end

        nil
      end
    end
  end
end
