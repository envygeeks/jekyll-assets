# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require_relative "proxies"
require "forwardable"

module Jekyll
  module Assets
    module Liquid

      # ----------------------------------------------------------------------
      # Examples:
      #   - {% tag value argument:value %}
      #   - {% tag value "argument:value" %}
      #   - {% tag value argument:"I have spaces" %}
      #   - {% tag value argument:value\:with\:colon %}
      #   - {% tag value argument:"I can even escape \\: here too!" %}
      #   - {% tag value proxy:key:value %}
      # ----------------------------------------------------------------------

      class Tag
        class Parser
          attr_reader :args, :raw_args
          extend Forwardable

          def_delegator :@args, :each
          def_delegator :@args, :key?
          def_delegator :@args, :fetch
          def_delegator :@args, :store
          def_delegator :@args, :to_h
          def_delegator :@args, :[]=
          def_delegator :@args, :[]

          # ------------------------------------------------------------------

          ACCEPT = {
            "css" => "text/css", "js" => "application/javascript"
          }

          # ------------------------------------------------------------------

          class UnescapedColonError < StandardError
            def initialize
              super "Unescaped double colon argument."
            end
          end

          # ------------------------------------------------------------------

          class UnknownProxyError < StandardError
            def initialize
              super "Unknown proxy argument."
            end
          end

          # ------------------------------------------------------------------

          def initialize(args, tag, processed: false, raw_args: nil)
            if processed && raw_args
              @args = args
              @raw_args = raw_args
              @tag = tag

            elsif processed && !raw_args
              raise ArgumentError, "You must provide raw_args if you pre-process." \
                "Please provide the raw args."

            else
              @tag = tag
              @raw_args = args
              parse_raw
              set_accept
            end
          end

          # ------------------------------------------------------------------

          def parse_liquid(context)
            return self unless context.is_a?(Object::Liquid::Context)
            liquid = context.registers[:site].liquid_renderer.file("(jekyll:assets)")
            out = parse_hash_liquid(to_h, liquid, context)
            self.class.new(out, @tag, {
              :raw_args => @raw_args,
              :processed => true
            })
          end

          # ------------------------------------------------------------------

          def to_html
            (self[:html] || {}).map do |key, val|
              val == true || val == "true" ? " #{key}" : %( #{key}="#{val}")
            end.join
          end

          # ------------------------------------------------------------------

          def proxies
            keys = (args.keys - Proxies.base_keys - [:file, :html])
            args.select do |key, _|
              keys.include?(key)
            end
          end

          # ------------------------------------------------------------------

          def proxies?
            proxies.any?
          end

          # ------------------------------------------------------------------

          private
          def parse_hash_liquid(hash_, liquid, context)
            hash_.each_with_object({}) do |(key, val), hash|
              val = liquid.parse(val).render(context) if val.is_a?(String)
              val = parse_hash_liquid(val, liquid, context) if val.is_a?(Hash)
              hash[key] = val
            end
          end

          # ------------------------------------------------------------------

          private
          def parse_raw
            @args = from_shellwords.each_with_index.each_with_object({}) do |(key, index), hash|
              if index == 0 then hash.store(:file, key)
              elsif key =~ /:/ && (key = key.split(/(?<!\\):/))
                parse_col hash, key

              else
                (hash[:html] ||= {})[key] = true
              end

              hash
            end
          end

          # ------------------------------------------------------------------

          private
          def parse_col(hash, key)
            key.push(key.delete_at(-1).gsub(/\\:/, ":"))
            return as_proxy hash, key if key.size == 3
            return as_bool_or_html hash, key if key.size == 2 || key.size == 1
            raise UnescapedColonError
          end

          # ------------------------------------------------------------------

          private
          def as_bool_or_html(hash, key)
            okey = key
            key, sub_key = key
            if Proxies.has?(key, @tag, "@#{sub_key}")
              (hash[key.to_sym] ||= {})[sub_key.to_sym] = true
            else
              (hash[:html] ||= {})[key] = \
                okey[1]
            end
          end

          # ------------------------------------------------------------------

          private
          def as_proxy(hash, key)
            key, sub_key, val = key
            if Proxies.has?(key, @tag, sub_key)
              (hash[key.to_sym] ||= {})[sub_key.to_sym] = \
                val

            elsif Proxies.has?(key)
              raise UnknownProxyError
            end
          end

          # ------------------------------------------------------------------

          private
          def set_accept
            if ACCEPT.key?(@tag) && (!@args.key?(:sprockets) || \
                  !@args[:sprockets].key?(:accept))

              (@args[:sprockets] ||= {})[:accept] = \
                ACCEPT[@tag]
            end
          end

          # ------------------------------------------------------------------

          private
          def from_shellwords
            Shellwords.shellwords(@raw_args)
          end
        end
      end
    end
  end
end
