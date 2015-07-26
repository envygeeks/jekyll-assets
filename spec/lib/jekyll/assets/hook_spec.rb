require "rspec/helper"

describe Jekyll::Assets::Hook do
  it "allows registration of receivers onto hook points" do
    Jekyll::Assets::Hook.register(:env, :pre_init, &proc {})
    expect(Jekyll::Assets::Hook.all[:env][:pre_init].size).to eq 1
  end

  it "raises if there is no hook" do
    expect { Jekyll::Assets::Hook.register(:unknown, :unknown, &proc {}) }.to \
      raise_error Jekyll::Assets::Hook::UnknownHookError
  end

  it "raises if there is no hook point" do
    expect { Jekyll::Assets::Hook.register(:env, :unknown, &proc {}) }.to \
      raise_error Jekyll::Assets::Hook::UnknownHookError
  end

  it "sends a message to hooks on a point to all receivers" do
    result, tproc = 1, proc { result = 2 }
    Jekyll::Assets::Hook.register(:env, :pre_init, &tproc)
    Jekyll::Assets::Hook. trigger(:env, :pre_init)
    expect(result).to eq 2
  end
end
