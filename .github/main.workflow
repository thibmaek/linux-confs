workflow "On PR" {
  resolves = ["shellcheck"]
  on = "pull_request"
}

action "shellcheck" {
  uses = "ludeeus/action-shellcheck@0.1.0"
}
