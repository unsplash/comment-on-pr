class GitHub
  class MissingPR < StandardError; end

  attr_reader :client

  def initialize(env:)
    @env = env
    @client = Octokit::Client.new(access_token: env["GITHUB_TOKEN"])
  end

  def event
    @_event ||= JSON.parse(File.read(@env.fetch("GITHUB_EVENT_PATH")))
  end

  def repo
    @_repo ||= event["repository"]["full_name"]
  end

  def pr_number
    @_pr ||= begin

      if @env.fetch("GITHUB_EVENT_NAME") == "pull_request"
        pr_number = event["number"]
      else
        pulls = client.pull_requests(repo, state: "open")

        push_head = event["after"]
        pr = pulls.find { |pr| pr["head"]["sha"] == push_head }

        if !pr
          raise MissingPR, "Couldn't find an open pull request for branch with head at #{push_head}"
        end

        pr["number"]
      end

    end
  end

  def comments
    @_comments ||= client.issue_comments(repo, pr_number)
  rescue MissingPR => e
    puts e.message
    exit(1)
  end

  def comment!(msg)
    client.add_comment(repo, pr_number, message)
  rescue MissingPR => e
    puts e.message
    exit(1)
  end
end
