# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::Liquid::Tag do
  let(:env) { Jekyll::Assets::Env.new(jekyll) }
  let(:jekyll) { stub_jekyll_site }

  it "puts me into pry" do
    require"pry"
    Pry.output = STDOUT
    binding.pry
  end
end
