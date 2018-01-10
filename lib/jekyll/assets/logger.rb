# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "jekyll"

module Jekyll
  module Assets
    class Logger
      PREFIX = "Assets: "
      COLORS = {
        error: :red,
        debug: :yellow,
        info:  :cyan,
      }.freeze

      # --
      def self.logger
        self
      end

      # --
      def self.with_timed_logging(msg, type: :debug)
        s, t, out = Time.now, nil, yield; Logger.send(type) do
          format("\n#{msg}", {
            time: "#{t = Time.now - s}s",
          })
        end

        {
          result: out, time: t
        }
      end

      # --
      def self.err_file(file)
        Jekyll.logger.error("Asset File", file)
      end

      # --
      def self.colorize?
        @color ||= begin
          Jekyll.env == "development" && system("test -t 2")
        end
      end

      # --
      # Makes a logging method
      # @param type [Symbol] the type of logger.
      # @return nil
      # --
      def self.make_logger(type:)
        define_singleton_method type do |m = nil, &b|
          m = (b ? b.call : m).gsub(Pathutil.pwd + "/", "")
          r = m =~ %r!writing\s+!i ? :debug : type
          Jekyll.logger.send(r, PREFIX, m)
        end
      end

      # --
      private_class_method :make_logger

      # --
      # @note this is to be removed after 3.6.
      # Creates self methods so that we can accept blocks.
      # @param [String,Proc] message the message that to log.
      # @return nil
      # --
      %i(warn error info debug).each do |v|
        make_logger({
          type: v,
        })
      end
    end
  end
end
