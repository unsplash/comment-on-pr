require "spec_helper"

RSpec.describe "action.rb" do

  let(:base_env) do
    {
      "GITHUB_TOKEN" => "secret",
      "GITHUB_EVENT_PATH" => File.join(__dir__, "event.json")
    }
  end

  before :each do
    stub_const("ARGV", ["hello"])
  end

  describe "required arguments" do
    it "fails without GITHUB_TOKEN" do
      expect { run }.to output(/Missing GITHUB_TOKEN/).to_stdout
      expect(run).to eq 1
    end

    it "fails without message" do
      stub_const("ENV", base_env)
      stub_const("ARGV", [])
      expect { run }.to output(/Missing message argument/).to_stdout
      expect(run).to eq 1
    end
  end

  describe "blocking duplicate comments" do

    before :each do
      stub_const("ENV", base_env)
    end

    context "we are blocking duplicates" do
      before :each do
        allow_any_instance_of(Commenter).to receive(:block_duplicates?).and_return(true)
      end

      it "exits when there is already a matching comment" do
        allow_any_instance_of(Commenter).to receive(:existing_duplicates?).and_return(true)
        expect { run }.to output(/The PR already contains this message/).to_stdout
        expect(run).to eq 0
      end

      it "comments when no match" do
        allow_any_instance_of(Commenter).to receive(:existing_duplicates?).and_return(false)
        allow_any_instance_of(Commenter).to receive(:comment!)
        expect { run }.to_not output.to_stdout
        expect(run).to eq 0
      end
    end

    context "not blocking duplicates" do
      before :each do
        allow_any_instance_of(Commenter).to receive(:block_duplicates?).and_return(false)
      end

      it "comments even with match" do
        allow_any_instance_of(Commenter).to receive(:existing_duplicates?).and_return(true)
        allow_any_instance_of(Commenter).to receive(:comment!)
        expect { run }.to_not output.to_stdout
        expect(run).to eq 0
      end

      it "comments when no match" do
        allow_any_instance_of(Commenter).to receive(:existing_duplicates?).and_return(false)
        allow_any_instance_of(Commenter).to receive(:comment!)
        expect { run }.to_not output.to_stdout
        expect(run).to eq 0
      end
    end

  end
end
