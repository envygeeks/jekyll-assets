# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "jekyll"

module Jekyll
  module Assets
    class Logger
      PREFIX = "Assets: "
      def self.logger
        self
      end

      # --
      # @note this is to be removed after 3.6.
      # Creates self methods so that we can accept blocks.
      # @param [String,Proc] message the message that to log.
      # @return nil
      # --
      %i(warn error info debug).each do |v|
        define_singleton_method v do |m = nil, &b|
          m = (b ? b.call : m).gsub(Pathutil.pwd + "/", "")
          p = colorize? ? PREFIX.magenta.bold : PREFIX
          r = m =~ %r!writing\s+!i ? :debug : v

          m = m.red if v == :error && colorize?
          m = m.yellow if v == :debug && colorize?
          m = m.cyan if colorize?

          Jekyll.logger.send(r, p, m)
        end
      end

      # --
      def self.efile(file)
        Jekyll.logger.error("Asset File", file)
      end

      # --
      def self.colorize?
        @color ||= begin
          Jekyll.env == "development" && system("test -t 2")
        end
      end
    end
  end
end
