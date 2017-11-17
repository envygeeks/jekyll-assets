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
        define_singleton_method v do |message = nil, &block|
          message = block.call if block
          Jekyll.logger.send(v, PREFIX, message)
        end
      end

      # --
      def self.efile(file)
        Jekyll.logger.error("Asset File", file)
      end
    end
  end
end
