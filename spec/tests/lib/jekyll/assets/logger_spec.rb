# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "rspec/helper"
describe Jekyll::Assets::Logger do
  before do
    Jekyll.logger.log_level = :debug
  end

  #

  after do
    Jekyll.logger.log_level = :info
  end

  #

  let :logger do
    described_class.new
  end

  #

  %W(warn error info debug).each do |v|
    it "allows blocks to be passed into the log method #{v}" do
      out = capture_stdout do
        logger.send(v) do
          v
        end
      end

      expect(strip_ansi(out.last.empty?? out.first : out.last).strip).to eq(
        "Jekyll Assets: #{v}"
      )
    end

    #

    it "does not prevent standard strings on the method #{v}" do
      out = capture_stdout do
        logger.send(v, v.to_s)
      end

      expect(strip_ansi(out.last.empty?? out.first : out.last).strip).to eq(
        "Jekyll Assets: #{v}"
      )
    end
  end

  #

  it "should raise if trying to set log level" do
    expect { logger.log_level = :debug }.to raise_error(
      RuntimeError
    )
  end
end
