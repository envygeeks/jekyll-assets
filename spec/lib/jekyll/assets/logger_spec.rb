require "rspec/helper"

describe Jekyll::Assets::Logger do
  before { Jekyll.logger.log_level = :debug }
   after { Jekyll.logger.log_level =  :info }
  let(:logger) { described_class.new }

  %W(warn error info debug).each do |v|
    it "allows blocks to be passed into the log method #{v}" do
      out = capture_stdout do
        logger.send(v) do
          v
        end
      end

      expect(strip_ansi(out.last.empty?? out.first : out.last).strip).to eq \
        "Jekyll Assets: #{v}"
    end

    it "does not prevent standard strings on the method #{v}" do
      out = capture_stdout do
        logger.send(v, v.to_s)
      end

      expect(strip_ansi(out.last.empty?? out.first : out.last).strip).to eq \
        "Jekyll Assets: #{v.to_s}"
    end
  end

  it "should raise if trying to set log level" do
    expect { logger.log_level = :debug }.to raise_error RuntimeError
  end
end
