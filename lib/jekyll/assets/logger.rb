# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
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
          format("\n#{msg}", "#{t = Time.now - s}s")
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
          p = colorize? ? PREFIX.magenta.bold : PREFIX

          r = m =~ %r!writing\s+!i ? :debug : type
          Jekyll.logger.send(r, p, colorize_msg(m, {
            type: r,
          }))
        end
      end

      # --
      # @param str [String] the string to colorize.
      # @param type [Symbol,String] the type of log method.
      # Colorizes a log message to the proper color.
      # --
      def self.colorize_msg(str, type:)
        return str unless colorize?
        (c = COLORS[type]) ? str.send(c) \
          : str
      end

      # --
      private_class_method :make_logger
      private_class_method :colorize_msg
      private_class_method :colorize?

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
