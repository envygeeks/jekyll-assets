module Jekyll
  module Assets

    # -------------------------------------------------------------------------
    # Examples:
    #   - {% tag value argument:value %}
    #   - {% tag value "argument:value" %}
    #   - {% tag value argument:"I have spaces" %}
    #   - {% tag value argument:value\:with\:colon %}
    #   - {% tag value argument:"I can even escape \\: here too!" %}
    # -------------------------------------------------------------------------
    # XXX: This code is pretty nasty in the way that it handles sorting.
    # -------------------------------------------------------------------------

    class Tag
      class Parser
        attr_reader :args, :raw_args

        ACCEPT = { "css" => "text/css", "js" => "application/javascript" }
        ACCEPT["javascript"] = ACCEPT[ "js"]
        ACCEPT["style"]      = ACCEPT["css"]
        ACCEPT["stylesheet"] = ACCEPT["css"]
        ACCEPT.freeze

        PROXY = {
          :find => [
            "accept"
          ],

          :write => [
            "resize",
            "convert",
            "crop",
            "@2x"
          ]
        }

        class UnescapedDoubleColonError < StandardError
          def initialize
            super "Unescaped double colon argument."
          end
        end

        def initialize(args, tag)
          @raw_args, @tag = args, tag

          parse_raw
          sort_base_args
          set_accept
        end

        def [](key)
          @args[
            key
          ]
        end

        def to_html
          @args[:other].map do |k, v|
            %Q{ #{k}="#{v}"}
          end. \
          join
        end

        # Very rudamentary sort before we do a more fine-grained sort
        # later in the code, this basically just takes the first arg and then
        # every other non-colon (valued) argument and pushes it.

        private
        def parse_raw
          @args = from_shellwords.inject(base_args) do |h, k|
            if (k = k.split(/(?<!\\):/)).size >= 3
              raise UnescapedDoubleColonError

            elsif k.size == 2
              h.update(
                k[0] => k[1].gsub(
                  /\\:/, ":"
                )
              )
            else
              h[h[:file].size == 1 ? :args : :file] << \
                k[0]
            end

            h
          end
        end

        # If it's not a proxy argument (going into Sprockets) or an
        # argument that sets a boolean choice for us (such as convert) then
        # we pass it onto other, where it will become an HTML attr.

        private
        def sort_base_args
          @args = @args.inject(base_sorted_args) do |h, (k, v)|
            if (find = PROXY[:find].include?(k)) || PROXY[:write].include?(k)
              h[:proxy][find ? :find : :write].update(
                find ? k.to_sym : k => v
              )

            elsif k == :file
              h[:file] = v. \
                first

            elsif k == :args
              v.each do |s|
                if PROXY[:write].include?(s)
                  h[:proxy][:write][s] = \
                    true
                else
                  h[:other].update(
                    s => true
                  )
                end
              end

            else
              h[:other].update(
                k => v
              )
            end

            h
          end
        end

        # If you try to tap bundle and you have bundle.css and bundle.js
        # it will return whichever one it chooses to parse first, so by default
        # we add a proxy with accept so that we can pick out what we would
        # prefer to be the default so you can do it Rails Style.
        #
        # This can also be achieved by you with accept:content_type on tag.

        private
        def set_accept
          unless @args[:proxy][:find][:accept]
            then @args[:proxy][:find][:accept] = ACCEPT[
              @tag
            ]
          end
        end

        private
        def sproxy
        end

        private
        def base_args
          {
            :file => Set.new,
            :args => Set.new
          }
        end

        private
        def base_sorted_args
          {
            :other => {},
            :proxy => {
              :find  => {},
              :write => {}
            }
          }
        end

        private
        def from_shellwords
          Shellwords.shellwords(
            @raw_args
          )
        end
      end
    end
  end
end
