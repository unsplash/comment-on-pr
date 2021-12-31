  require "spec_helper"

  RSpec.describe Commenter do
  let(:github) do
    spy("GitHub", comments: [
      { "body" => "Oh, hi! I didn't see you there." },
      { "body" => "Ah, that's just because of my invisibility powers." }
    ],
    delete_comment: true)
  end

  describe "#block_duplicates?" do
    it "default" do
      commenter = Commenter.new(github: github, message: "")
      expect(commenter.block_duplicates?).to eq true
    end

    it "given true" do
      commenter = Commenter.new(github: github, message: "", check_for_duplicates: true)
      expect(commenter.block_duplicates?).to eq true
    end

    it "given 'true'" do
      commenter = Commenter.new(github: github, message: "", check_for_duplicates: "true")
      expect(commenter.block_duplicates?).to eq true
    end

    it "given 'false'" do
      commenter = Commenter.new(github: github, message: "", check_for_duplicates: false)
      expect(commenter.block_duplicates?).to eq false
    end

    it "given nil" do
      commenter = Commenter.new(github: github, message: "", check_for_duplicates: nil)
      expect(commenter.block_duplicates?).to eq false
    end
  end

  describe "#existing_duplicates?" do
    context "default/no pattern" do
      it "finds exact comment" do
        commenter = Commenter.new(github: github, message: "Ah, that's just because of my invisibility powers.")
        expect(commenter.existing_duplicates?).to eq true
      end

      it "gives false when no matches" do
        commenter = Commenter.new(github: github, message: "Today I will say a sentence never been said.")
        expect(commenter.existing_duplicates?).to eq false
      end
    end

    context "given pattern" do
      it "finds matching comment" do
        commenter = Commenter.new(github: github, message: "Is anyone listening?", duplicate_pattern: "invisibility powers")
        expect(commenter.existing_duplicates?).to eq true
      end

      it "gives false when no matches" do
        commenter = Commenter.new(github: github, message: "Is anyone listening?", duplicate_pattern: "common idioms")
        expect(commenter.existing_duplicates?).to eq false
      end
    end
  end

  describe "#delete_matching_comments!" do
    it "does nothing by default" do
      commenter = Commenter.new(github: github, message: "")
      expect(commenter.delete_matching_comments!).to eq nil
      expect(github).to have_received(:delete_comment).exactly(0).times
    end

    it "does nothing given empty string" do
      commenter = Commenter.new(github: github, message: "", delete_previous_pattern: "")
      expect(commenter.delete_matching_comments!).to eq nil
      expect(github).to have_received(:delete_comment).exactly(0).times
    end

    it "deletes matching comments given pattern" do
      commenter = Commenter.new(github: github, message: "", delete_previous_pattern: "invisibility")
      expect(commenter.delete_matching_comments!).to_not eq nil
      expect(github).to have_received(:delete_comment).once
    end
  end

  end
