module Jekyll
  module Assets
    class Tag
      module Proxies
        def self.add(cls, name, tag, args)
          names = [name, name.to_s, name.to_sym]
          tags  =  [tag].flatten.map { |v| [v.to_s, v, v.to_sym] }
          args  = [args].flatten.map { |v| [v.to_s, v, v.to_sym] }

          all << {
            :name => names.uniq,
            :tags => tags.flatten.uniq,
            :args => args.flatten.uniq,
            :cls  => cls
          }
        all
        end

        def self.keys
          all.select { |v| !v[:cls].is_a?(Symbol) }.map do |v|
            v[:name]
          end. \
          flatten
        end

        def self.base_keys
          all.select { |v| v[:cls].is_a?(Symbol) }.map do |v|
            v[:name]
          end. \
          flatten
        end

        def self.has?(name, tag = nil, arg = nil)
          get(name, tag, arg).any?
        end

        def self.get(name, tag = nil, arg = nil)
          if name && tag && arg
            get_by_name_and_tag_and_arg(
              name, tag, arg
            )
          elsif name && tag
            get_by_name_and_tag(
              name, tag
            )
          else
            all.select do |v|
              v[:name].include?(name)
            end
          end
        end

        def self.get_by_name_and_tag_and_arg(name, tag, arg)
          all.select do |v|
            (v[:name].include?(name))   && \
            (v[:tags].include?(:all)    || \
                v[:tags].include?(tag)) && \
            (v[:args].include?( arg))
          end
        end

        def self.get_by_name_and_tag(name, tag)
          all.select do |v|
            (v[:name].include?(name))   &&
            (v[:tags].include?(:all)    || \
                v[:tags].include?(tag))
          end
        end

        def self.all
          @_all ||= Set.new
        end

        # TODO: Put in a better place.
        add :internal, :data, :all, ["@uri"]
        add :internal, :sprockets, :all, [
          "accept", "write_to"
        ]
      end
    end
  end
end

Jekyll::Assets::Helpers.try_require("mini_magick") { require_relative "proxies/magick" }
