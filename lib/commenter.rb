class Commenter
  def initialize(github:, message:, check_for_dupes: true, duplicate_pattern: nil, delete_previous_pattern: nil)
    @github = github
    @message = message
    @block_duplicates = check_for_dupes.to_s.downcase.strip == "true"
    @duplicate_pattern = !duplicate_pattern.to_s.empty? && Regexp.new(duplicate_pattern)
    @delete_previous_pattern = !delete_previous_pattern.to_s.empty? && Regexp.new(delete_previous_pattern)
  end

  def block_duplicates?
    @block_duplicates
  end

  def existing_duplicates?
    if @duplicate_pattern
      @github.comments.any? { |c| c["body"].match(/#{@duplicate_pattern}/) }
    else
      @github.comments.any? { |c| c["body"] == message }
    end
  end

  def delete_matching_comments!
    return if !@delete_previous_pattern

    comments.each do |comment|
      if comment["body"].match(/#{@delete_prev_regex_msg}/)
        @github.delete_comment(repo, comment["id"])
      end
    end
  end

  def comment!
    @github.comment!(@message)
  end
end
