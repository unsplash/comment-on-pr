# Comment on PR via GitHub Action

A GitHub action to comment on the relevant open PR when a commit is pushed.

## Usage

- Requires the `GITHUB_TOKEN` secret.
- Requires the comment's message in the `args`.

### Sample workflow

```
workflow "comment-on-pr example" {
  on = "push"
  resolves = ["unsplash/comment-on-pr@master"]
}

action "unsplash/comment-on-pr@master" {
  uses = "unsplash/comment-on-pr@master"
  args = ["Check out this message!"]
  secrets = ["GITHUB_TOKEN"]
}
```
