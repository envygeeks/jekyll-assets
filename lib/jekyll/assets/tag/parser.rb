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

        PROXY  = {
          "data" => {
            :for => :all,
            :key => [
              "@uri"
            ]
          },

          "sprockets" => {
            :for => :all,
            :key => [
              "accept",
              "write_to"
            ]
          }
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
          @raw_args = args
          @tag = tag
          parse_raw
          set_accept
        end

        def proxies
          @_proxies ||= Proxies.all.each_with_object(PROXY.dup) do |k, h|
            h[k.args[:name].to_s] = k.args
          end
        end

        def to_html
          @args[:html].map do |k, v|
            %Q{ #{k}="#{v}"}
          end. \
          join
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
          if is_proxy?(k[0]) && proxies[k[0]][:key].include?("@#{k[1]}")
            h[k[0].to_sym][k[1].to_sym] = true
          else
            h[:html][k[0]] = k[1]
          end
        end

        private
        def as_proxy(h, k)
          if is_proxy?(k[0]) && proxies[k[0]][:key].include?(k[1])
            h[k[0].to_sym][k[1].to_sym] = \
              k[2]

          elsif is_proxy?(k[0])
            raise UnknownProxyError
          end
        end

        def is_proxy?(k)
          proxies[k] && (proxies[k][:for] == :all || proxies[k][:for] == @tag)
        end

        private
        def set_accept
          if !@args[:sprockets][:accept] && (accept = ACCEPT[@tag])
            then @args[:sprockets][:accept] = \
              accept
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
