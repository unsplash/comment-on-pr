#!/usr/bin/env ruby

require "json"
require "octokit"

json = File.read(ENV.fetch("GITHUB_EVENT_PATH"))
push = JSON.parse(json)

github = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])

if !ENV["GITHUB_TOKEN"]
  puts "Missing GITHUB_TOKEN"
  exit(1)
end

if ARGV.empty?
  puts "Missing message argument."
  exit(1)
end

repo = push["repository"]["full_name"]
pulls = github.pull_requests(repo, state: "open")

push_head = push["after"]
pr = pulls.find { |pr| pr["head"]["sha"] == push_head }

if !pr
  puts "Couldn't find an open pull request for branch with head at #{push_head}."
  exit(1)
end

message = ARGV.join(' ')
github.add_comment(repo, pr["number"], message)
