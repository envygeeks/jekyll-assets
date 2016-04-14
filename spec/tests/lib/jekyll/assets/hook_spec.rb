# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "rspec/helper"
describe Jekyll::Assets::Hook do
  before :each do
    Jekyll::Assets::Hook::HOOK_POINTS.store(:test, [:test])
    Jekyll::Assets::Hook.all.store(:test, {
      :test => {
        :early => Set.new, :late => Set.new
      }
    })
  end

  #

  it "allows registration of receivers onto points" do
    hooks = Jekyll::Assets::Hook.point(:test, :test, :late)
    Jekyll::Assets::Hook.register(:test, :test, &proc {})
    expect(hooks.size).to eq(
      1
    )
  end

  #

  it "raises if there is no hook" do
    expect { Jekyll::Assets::Hook.register(:unknown, :unknown, &proc {}) }.to(
      raise_error Jekyll::Assets::Hook::UnknownHookError
    )
  end

  #

  it "raises if there is no hook point" do
    expect { Jekyll::Assets::Hook.register(:env, :unknown, &proc {}) }.to(
      raise_error Jekyll::Assets::Hook::UnknownHookError
    )
  end

  #

  it "sends a message to all receivers on a point" do
    result = 1; tproc = proc { result = 2 }
    Jekyll::Assets::Hook.register(:test, :test, &tproc)
    Jekyll::Assets::Hook. trigger(:test, :test)
    expect(result).to eq 2
  end
end
