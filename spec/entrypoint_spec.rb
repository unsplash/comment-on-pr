require "spec_helper"

RSpec.describe "entrypoint.sh" do

  def run_script(env = {}, args = [])
    path = File.join(__dir__, "../entrypoint.sh")
    Open3.capture3(env, path, *args)
  end

  let(:base_env) do
    {
      "GITHUB_TOKEN" => "secret",
      "GITHUB_EVENT_PATH" => File.join(__dir__, "event.json")
    }
  end

  it "fails without GITHUB_TOKEN" do
    out, err, status = run_script
    expect(out).to eq "Missing GITHUB_TOKEN\n"
    expect(status.success?).to eq false
  end

  it "fails without message" do
    out, err, status = run_script(base_env)
    expect(out).to eq "Missing message argument.\n"
    expect(status.success?).to eq false
  end
end
