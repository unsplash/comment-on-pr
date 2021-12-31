require "spec_helper"

RSpec.describe GitHub do
  describe "#pr_number" do

    let(:client) do
      double("GitHub client", pull_requests:
        [
          {
            "number" => 1234,
            "head" => {
              "sha" => "abc123"
            }
          },
          {
            "number" => 5678,
            "head" => {
              "sha" => "def456"
            }
          }
        ])
    end

    it "gives correct number for pull_request events" do
      github = GitHub.new(env: { "GITHUB_TOKEN" => "secret", "GITHUB_EVENT_NAME" => "pull_request" })
      allow(github).to receive(:event).and_return({ "number" => 1234 })

      expect(github.pr_number).to eq 1234
    end

    context "other events" do

      before :each do
        @github = GitHub.new(env: { "GITHUB_TOKEN" => "secret", "GITHUB_EVENT_NAME" => "push" })
        allow(@github).to receive(:client).and_return(client)
      end

      it "finds the existing PR" do
        allow(@github).to receive(:event).and_return({
          "after" => "def456",
          "repository" => {
            "full_name" => "foo/bar"
          }
        })
        expect(@github.pr_number).to eq 5678
      end

      it "raises if no PR found" do
        @github = GitHub.new(env: { "GITHUB_TOKEN" => "secret", "GITHUB_EVENT_NAME" => "push" })
        allow(@github).to receive(:event).and_return({
          "after" => "ghi789",
          "repository" => {
            "full_name" => "foo/bar"
          }
        })
        allow(@github).to receive(:client).and_return(client)
        expect { @github.pr_number }.to raise_error(GitHub::MissingPR)
      end
    end

  end
end
