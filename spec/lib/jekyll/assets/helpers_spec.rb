require "rspec/helper"
describe Jekyll::Assets::Helpers do
  let :klass do
    Jekyll::Assets::Helpers
  end

  context "#has_javascript?" do
    it "runs the block if there is a JavaScript (any) available" do
      expect(klass.has_javascript? { true }).to eq \
        true
    end

    it "logs when it cannot load a JavaScript runtime" do
      expect(Jekyll.logger).to receive(:debug).with(any_args)
      klass.has_javascript? do
        raise ExecJS::RuntimeUnavailable
      end
    end
  end

  context "#try_require" do
    it "does not raise when the file doesn't exist" do
      result = klass.try_require("if_this_exists_we_are_screwed") { "hello" }
      expect(result).to \
        be_nil
    end

    it "runs your code if the file exists" do
      result = klass.try_require("jekyll/assets") { "hello" }
      expect(result).to eq \
        "hello"
    end
  end

  context "#try_require_if_javascript?" do
    it "runs your code if both JavaScript and the file exists" do
      result = klass.try_require_if_javascript?("jekyll/assets") { "hello" }
      expect(result).to eq \
        "hello"
    end

    it "does not run your code if JavaScript does not exist" do
      allow(klass).to receive(:require).and_raise ExecJS::RuntimeUnavailable
      result = klass.try_require_if_javascript?("jekyll/assets") { "hello" }
      expect(result).to \
        be_nil
    end

    it "does not run or pass the error if the file does not exist" do
      allow(klass).to receive(:require).and_raise LoadError
      result = klass.try_require_if_javascript?("jekyll/assets") { "hello" }
      expect(result).to \
        be_nil
    end
  end
end
