# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

module Shared
  extend RSpec::SharedContext

  let(:jekyll) { site }
  let(:sprockets) { env }
  let(:site) { stub_jekyll_site }
  subject { described_class }
  let(:env) { stub_env }
end

RSpec.configure do |c|
  c.include Shared
end
