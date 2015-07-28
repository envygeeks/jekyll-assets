require_relative "proxies"
require "forwardable"

module Jekyll
  module Assets

    # Examples:
    #   - {% tag value argument:value %}
    #   - {% tag value "argument:value" %}
    #   - {% tag value argument:"I have spaces" %}
    #   - {% tag value argument:value\:with\:colon %}
    #   - {% tag value argument:"I can even escape \\: here too!" %}
    #   - {% tag value proxy:key:value %}

    class Tag
      class Parser
        attr_reader :args, :raw_args
        extend Forwardable

        def_delegator :@args, :to_h
        def_delegator :@args, :has_key?
        def_delegator :@args, :fetch
        def_delegator :@args, :[]

        ACCEPT = {
          "css" => "text/css", "js" => "application/javascript"
        }

        class UnescapedColonError < StandardError
          def initialize
            super "Unescaped double colon argument."
          end
        end

        class UnknownProxyError < StandardError
          def initialize
            super "Unknown proxy argument."
          end
        end

        def initialize(args, tag)
          @raw_args, @tags = args, tag
          @tag = tag
          parse_raw
          set_accept
        end

        def to_html
          @args[:html].map do |k, v|
            %Q{ #{k}="#{v}"}
          end. \
          join
        end

        def proxies
          keys = (args.keys - Proxies.base_keys - [:file, :html])
          args.select do |k, v|
            keys.include?(k)
          end
        end

        def has_proxies?
          proxies.any?
        end

        private
        def parse_raw
          @args = from_shellwords.each_with_index.inject(dhash) do |h, (k, i)|
            if i == 0 then h[:file] = k
              elsif k =~ /:/ && (k = k.split(/(?<!\\):/)) then parse_col h, k
              else h[:html][k] = true
            end

            h
          end
        end

        private
        def parse_col(h, k)
          k[-1] = k[-1].gsub(/\\:/, ":")
          if k.size == 3 then as_proxy h, k
            elsif k.size == 2 then as_bool_or_html h, k
            else raise UnescapedColonError
          end
        end

        private
        def as_bool_or_html(h, k)
          key, sub_key = k
          if Proxies.has?(key, @tag, "@#{sub_key}")
            h[key.to_sym][sub_key.to_sym] = true
          else
            h[:html][key] = k[1]
          end
        end

        private
        def as_proxy(h, k)
          key, sub_key, value = k
          if Proxies.has?(key, @tag, sub_key)
            h[key.to_sym][sub_key.to_sym] = \
              value
          elsif Proxies.has?(key)
            raise UnknownProxyError
          end
        end

        private
        def set_accept
          if (accept = ACCEPT[@tag]) && !args[:sprockets][:accept]
            @args[:sprockets][:accept]  =  accept
          end
        end

        private
        def dhash
          Hash.new do |h, k|
            h[k] = {}
          end
        end

        private
        def from_shellwords
          Shellwords.shellwords(@raw_args)
        end
      end
    end
  end
end
