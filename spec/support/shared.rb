# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Shared
  extend RSpec::SharedContext

  let(:sprockets) { env }
  subject { described_class }
  let(:environment) { stub_environment }
  let(:site) { stub_jekyll_site }
  let(:jekyll) { site }
end

RSpec.configure do |c|
  c.include Shared
end
