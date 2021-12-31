require "json"
require "octokit"
require_relative "../lib/github"
require_relative "../lib/commenter"

def stub_env(env)
  stub_const("ENV", ENV.to_hash.merge(env))
end
