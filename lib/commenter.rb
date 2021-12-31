class Commenter
  def initialize(github:, message:, check_for_duplicates: true, duplicate_pattern: nil, delete_previous_pattern: nil)
    @github = github
    @message = message
    @block_duplicates = check_for_duplicates.to_s.downcase.strip == "true"
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
      @github.comments.any? { |c| c["body"] == @message }
    end
  end

  def delete_matching_comments!
    return if !@delete_previous_pattern

    @github.comments.each do |comment|
      if comment["body"].match(/#{@delete_previous_pattern}/)
        @github.delete_comment(@github.repo, comment["id"])
      end
    end
  end

  def comment!
    @github.comment!(@message)
  end
end
