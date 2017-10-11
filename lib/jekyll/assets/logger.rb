# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    class Logger
      PREFIX = "Assets: "

      def self.logger
        self
      end

      def self.warn(msg = nil)
        msg = yield if block_given?
        Jekyll.logger.warn \
          PREFIX, msg
      end

      def self.error(msg = nil)
        msg = yield if block_given?
        Jekyll.logger.error \
          PREFIX, msg
      end

      def self.info(msg = nil)
        msg = yield if block_given?
        Jekyll.logger.info \
          PREFIX, msg
      end

      def self.debug(msg = nil)
        msg = yield if block_given?
        Jekyll.logger.debug \
          PREFIX, msg
      end
    end
  end
end
