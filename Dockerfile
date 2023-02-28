FROM ruby:3-alpine3.16

LABEL "com.github.actions.name"="Comment on PR"
LABEL "com.github.actions.description"="Leaves a comment on an open PR matching a push event."
LABEL "com.github.actions.repository"="https://github.com/unsplash/comment-on-pr"
LABEL "com.github.actions.maintainer"="Aaron Klaassen <aaron@unsplash.com>"
LABEL "com.github.actions.icon"="message-square"
LABEL "com.github.actions.color"="blue"

RUN gem install octokit -v 4.25.1

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
