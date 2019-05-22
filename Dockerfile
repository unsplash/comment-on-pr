FROM ruby:2.6.0

LABEL "com.github.actions.name"="Comment on PR"
LABEL "com.github.actions.description"="Leaves a comment on an open PR matching a push event."
LABEL "com.github.actions.icon"="filter"
LABEL "com.github.actions.color"="orange"

ADD bin /bin

RUN gem install octokit

ENTRYPOINT ["entrypoint"]
