# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::Liquid::Defaults do
  let :asset do
    env.manifest.find("ubuntu.png").first
  end

  # --
  class SpecDefaultsTestClass1 < Jekyll::Assets::Liquid::Default
    tags :test
    defaults({
      :hello => :world
    })
  end

  # --
  class SpecDefaultsTestClass2 < Jekyll::Assets::Liquid::Default
    tags :test
    defaults({
      :world => :hello
    })

    def run
      @args[:hello] = :world
    end
  end

  #

  describe "get_defaults" do
    it "should give an indifferent hash" do
      expect(subject.get_defaults(:test)).to(be_a(
        HashWithIndifferentAccess))
    end

    #

    it "should merge values" do
      expect(subject.get_defaults(:test)).to(eq({
        "hello" => :world,
        "world" => :hello,
      }))
    end
  end

  #

  describe "set_defaults" do
    it "should run and set defaults" do
      result = {}
      subject.set_defaults(:test, {
        args: result,
        asset: asset,
        env: env,
      })

      expect(result).to(have_key(:hello))
      expect(result[:hello]).
        to(eq(:world))
    end

    #

    it "should log if there is no runner" do
      expect(env.logger).to(receive(:debug).at_least(1).times)
      subject.set_defaults(:test, {
        args: {},
        asset: asset,
        env: env
      })
    end
  end
end
