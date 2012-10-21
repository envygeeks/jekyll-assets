require 'spec_helper'


module Jekyll::AssetsPlugin
  describe Logging do
    it 'puts strings with [AssetsPlugin] prefix' do
      loggable = Class.new do
        include Logging
        # make sure #log is public
        def log(*args) super; end
      end.new

      loggable.should_receive(:puts).with(match %r{^\[AssetsPlugin\]})
      loggable.log :info, 'test'
    end
  end
end
