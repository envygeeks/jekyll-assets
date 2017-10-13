# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

Jekyll::Hooks.register :site, :after_init do |o|
  o.config["exclude"].push(*Jekyll::Assets::Config.defaults[:sources]).uniq!
end
