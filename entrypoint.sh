#!/usr/bin/env ruby

require "json"
require "octokit"
require_relative "lib/github"
require_relative "lib/commenter"

if !ENV["GITHUB_TOKEN"]
  puts "Missing GITHUB_TOKEN"
  exit(1)
end

if ARGV[0].nil? || ARGV[0].empty?
  puts "Missing message argument."
  exit(1)
end

commenter = Commenter.new(github: GitHub.new(env: ENV),
                          message: ARGV[0],
                          check_for_duplicates: ARGV[1],
                          duplicate_pattern: ARGV[2],
                          delete_previous_pattern: ARGV[3])

if commenter.block_duplicates? && commenter.existing_duplicates?
  puts "The PR already contains this message"
  exit(0)
end

commenter.delete_matching_comments!
commenter.comment!
