# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    class Logger
      PREFIX = "Assets: "

      # --
      # logger allows you to delegate to this class without
      # having to create a whole new method.
      # @return [Logger]
      # --
      def logger
        self
      end

      # --
      # Log Level: 1
      # --
      def self.warn(msg = nil)
        msg = yield if block_given?
        Jekyll.logger.warn \
          PREFIX, msg
      end

      # --
      # Log Level: 1
      # --
      def self.error(msg = nil)
        msg = yield if block_given?
        Jekyll.logger.error \
          PREFIX, msg
      end

      # --
      # Log Level: 2
      # --
      def self.info(msg = nil)
        msg = yield if block_given?
        Jekyll.logger.info \
          PREFIX, msg
      end

      # --
      # Log Level: 3
      # --
      def self.debug(msg = nil)
        msg = yield if block_given?
        Jekyll.logger.debug \
          PREFIX, msg
      end
    end
  end
end
