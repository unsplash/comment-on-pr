#!/usr/bin/env ruby

require "json"
require "octokit"
require_relative "lib/github"
require_relative "lib/commenter"
require_relative "lib/action"

exit(run)
