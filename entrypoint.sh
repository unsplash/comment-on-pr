#!/usr/bin/env ruby

require "json"
require "octokit"

json = File.read(ENV.fetch("GITHUB_EVENT_PATH"))
event = JSON.parse(json)

if !ENV["GITHUB_TOKEN"]
  puts "Missing GITHUB_TOKEN"
  exit(1)
end

github = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])

if ARGV[0].empty?
  puts "Missing message argument."
  exit(1)
end

message = ARGV[0]
check_duplicate_msg = ARGV[1]
delete_prev_regex_msg = ARGV[2]
duplicate_msg_pattern = ARGV[3]

repo = event["repository"]["full_name"]

if ENV.fetch("GITHUB_EVENT_NAME") == "pull_request"
  pr_number = event["number"]
elsif ENV.fetch("GITHUB_EVENT_NAME") == "pull_request_review"
  pr_number = event["pull_request"]["number"]
else
  pulls = github.pull_requests(repo, state: "open")

  push_head = event["after"]
  pr = pulls.find { |pr| pr["head"]["sha"] == push_head }

  if !pr
    puts "Couldn't find an open pull request for branch with head at #{push_head}."
    exit(1)
  end
  pr_number = pr["number"]
end

if check_duplicate_msg == "true" || !delete_prev_regex_msg.empty?
  comments = github.issue_comments(repo, pr_number)

  if check_duplicate_msg == "true"
    duplicate = if !duplicate_msg_pattern.empty?
      comments.find { |c| c["body"].match(/#{duplicate_msg_pattern}/) }
    else
      comments.find { |c| c["body"] == message }
    end

    if duplicate
      puts "The PR already contains this message"
      exit(0)
    end
  end

  if !delete_prev_regex_msg.empty?
    comments.each do |comment|
      if comment["body"].match(/#{delete_prev_regex_msg}/)
        github.delete_comment(repo, comment["id"])
      end
    end
  end
end

github.add_comment(repo, pr_number, message)
