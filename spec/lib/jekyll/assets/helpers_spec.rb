require "rspec/helper"
describe Jekyll::Assets::Helpers do
  context "#has_javascript?" do
    it "works" do
      expect(described_class.has_javascript? { true }).to eq(
        true
      )
    end

    it "logs when it cannot load a JavaScript runtime" do
      expect(Jekyll.logger).to receive(:debug).with(any_args)
      described_class.has_javascript? do
        raise ExecJS::RuntimeUnavailable
      end
    end
  end

  context "#try_require" do
    it "does not raise when the file doesn't exist" do
      o = described_class.try_require "if_this_exists_we_are_screwed" do
        "wat?"
      end

      expect(o).to be_nil
    end

    it "runs your code if the file exists" do
      o = described_class.try_require "jekyll/assets" do
        "wat?"
      end

      expect(o).to eq(
        "wat?"
      )
    end
  end

  context "#try_require_if_javascript?" do
    it "just works" do
      o = described_class.try_require_if_javascript? "jekyll/assets" do
        "wat?"
      end

      expect(o).to eq(
        "wat?"
      )
    end
  end
end
