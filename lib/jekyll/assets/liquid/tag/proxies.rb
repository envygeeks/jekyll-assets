# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

module Jekyll
  module Assets
    module Liquid
      class Tag
        module Proxies
          def self.add_by_class(class_, name, tag, *args)
            proc_ = proc { |v| [v.to_s, v, v.to_sym] }
            all << {
              :name => proc_.call(name).uniq,
              :args => [args].flatten.map(&proc_).flatten.uniq,
              :tags => [ tag].flatten.map(&proc_).flatten.uniq,
              :class  => class_
            }

            all
          end

          # ------------------------------------------------------------------

          def self.add(name, tag, *args, &block)
            add_by_class(*generate_class(name, tag, &block), *args)
          end

          # ------------------------------------------------------------------

          def self.keys
            all.select { |val| !val[:class].is_a?(Symbol) }.map do |val|
              val[:name]
            end.flatten
          end

          # ------------------------------------------------------------------

          def self.base_keys
            all.select { |val| val[:class].is_a?(Symbol) }.map do |val|
              val[:name]
            end.flatten
          end

          # ------------------------------------------------------------------

          def self.has?(name, tag = nil, arg = nil)
            get(name, tag, arg).any?
          end

          # ------------------------------------------------------------------

          def self.get(name, tag = nil, arg = nil)
            if name && tag && arg then get_by_name_and_tag_and_arg(name, tag, arg)
            elsif name && tag
              get_by_name_and_tag(name, tag)

            else
              all.select do |val|
                val[:name].include?(name)
              end
            end
          end

          # ------------------------------------------------------------------

          def self.get_by_name_and_tag_and_arg(name, tag, arg)
            all.select do |val|
              val[:name].include?(name) && (val[:tags].include?(:all) || val[:tags] \
                .include?(tag)) && val[:args].include?(arg)
            end
          end

          # ------------------------------------------------------------------

          def self.get_by_name_and_tag(name, tag)
            all.select do |val|
              val[:name].include?(name) && (val[:tags].include?(:all) || val[:tags] \
                .include?(tag))
            end
          end

          # ------------------------------------------------------------------

          def self.all
            @_all ||= Set.new
          end

          # ------------------------------------------------------------------

          private_class_method
          def self.generate_class(name, tag, &block)
            class_ = const_set(random_name, Class.new)
            class_.class_eval(&block)
            return class_, name, tag
          end

          # ------------------------------------------------------------------

          private_class_method
          def self.random_name
            (0...12).map { ("a".."z").to_a.values_at(rand(26)) }.join.capitalize
          end

          # ------------------------------------------------------------------
          # TODO: Put in a better place.
          # ------------------------------------------------------------------

          add_by_class :internal, :data, :all, ["@uri"]
          add_by_class :internal, :sprockets, :all, %W(
            accept write_to
          )
        end
      end
    end
  end
end
