# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

Jekyll::Assets::Hook.register :env, :init, priority: 1 do
  @config = hash_reassoc @config, :registered_transformers do |o|
    o.delete_if do |v|
      v.proc == Sprockets::ERBProcessor
    end
  end
end
