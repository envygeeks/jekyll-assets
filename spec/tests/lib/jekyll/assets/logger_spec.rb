# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::Logger do
  it { respond_to :info }
  it { respond_to :error }
  it { respond_to :debug }
  it { respond_to :warn }

  %i(info error debug warn).each do |k|
    describe "##{k}" do
      it "should accept a block" do
        expect(Jekyll.logger).to(receive(k)).with(subject::PREFIX, "hello")
        subject.send(k) do
          "hello"
        end
      end
    end
  end
end
