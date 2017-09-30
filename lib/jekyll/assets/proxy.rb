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
      # @param [String] for_ the tag to search for
      # find_all will find all the proxies that support the
      # current tag, and then run said proxy, passing on temp_path
      # so that proxies can be chained.
      # @return [Array]
      # --
      def find_all(for_)
        @subs.select do |v|
          v::FOR.include?(for_)
        end
      end

      # --
      # @param [Proxy<>] proxies, the proxies to run
      # run will run all the proxies you ship us with the
      # arguments you give us.  Except for temp_path, we will
      # wrap in temp_path on your behalf.
      # @return [nil]
      # --
      def run(proxies, asset:, args:)
        file = temp_path
        proxies.each do |v|
          v.new(asset, args: args, temp_path: file)
        end
      end

      # --
      # temp_path creates a tempfile so that you can copy
      # data to it, without having to work inside of the users
      # working directory and causing trouble.
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
