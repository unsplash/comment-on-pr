FROM ruby:3-alpine3.13

LABEL "com.github.actions.name"="Comment on PR with Delete"
LABEL "com.github.actions.description"="Leaves a comment on an open PR matching a push event."
LABEL "com.github.actions.repository"="https://github.com/Ronald-Baars/comment-on-pr-delete"
LABEL "com.github.actions.maintainer"="Ronald Baars"
LABEL "com.github.actions.icon"="message-square"
LABEL "com.github.actions.color"="blue"

RUN gem install octokit

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
