# Comment on PR via GitHub Action

A GitHub action to comment on the relevant open PR when a commit is pushed.

## Usage

- Requires the `GITHUB_TOKEN` secret.
- Requires the comment's message in the `msg` parameter.
- Supports `push`, `pull_request` and `pull_request_review` event types.

### Sample workflow

```yaml
name: comment-on-pr example
on: pull_request
jobs:
  example:
    name: sample comment
    runs-on: ubuntu-latest
    steps:
      - name: comment PR
        uses: unsplash/comment-on-pr@v1.3.0
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          msg: "Check out this message!"  # OPTIONAL
          check_for_duplicate_msg: false  # OPTIONAL
          delete_prev_regex_msg: "[0-9]"  # OPTIONAL
          duplicate_msg_pattern: "[A-Z]"  # OPTIONAL
```

### Delete a message
if the `msg` property is not set, the rest of the rules will still run, this means that previous messages can be removed.

```yaml
name: comment-on-pr example
on: pull_request
jobs:
  example:
    name: sample comment
    runs-on: ubuntu-latest
    steps:
      - name: comment PR
        uses: unsplash/comment-on-pr@v1.3.0
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          check_for_duplicate_msg: false  # OPTIONAL
          delete_prev_regex_msg: "[0-9]"  # OPTIONAL
          duplicate_msg_pattern: "[A-Z]"  # OPTIONAL
```

## Properties in "with"
|                         | Required? | Type           | Description                                                                                             |
|-------------------------|-----------|----------------|---------------------------------------------------------------------------------------------------------|
| msg                     | no        | String         | The message that will be added to the PR                                                                |
| check_for_duplicate_msg | no        | Boolean        | Wether to check for duplicate messages or not.                                                          |
| delete_prev_regex_msg   | no        | Regex (string) | Regex pattern that will match existing comments. If a match is found, the old messages will be deleted. |
| duplicate_msg_pattern   | no        | Regex (string) | Regex pattern that will match existing comments                                                         |
