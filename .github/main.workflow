workflow "Cherry Pick Commit to Target Branch" {
  on = "pull_request"
  resolves = ["./cherry-pick-action"]
}

action "merged-filter" {
  uses = "actions/bin/filter@3c0b4f0e63ea54ea5df2914b4fabf383368cd0da"
  args = "merged false"
}

action "./cherry-pick-action" {
  uses = "./cherry-pick-action"
  needs = ["merged-filter"]
  args = "some value"
}