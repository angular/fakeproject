#!/bin/sh -l
GITHUB_EVENT_PATH="/event.json"

EVENT_ACTION=$(cat $GITHUB_EVENT_PATH | jq '.action')
DIFF_URL=$(cat $GITHUB_EVENT_PATH | jq '.pull_request.diff_url')

if [ "$GITHUB_EVENT_NAME" != "pull_request" ]; then
  echo "The github event was not pull_request";
  exit 78;
fi

PATCH_BRANCH=""
MINOR_BRANCH=""
MAJOR_BRANCH=""

# Is target: patch
if [ $(/containsLabel $GITHUB_EVENT_PATH "target: patch") == "true" ]; then
  PATCH_BRANCH=$(git ls-remote --heads upstream | grep -E 'refs\/heads\/[0-9]+\.[0-9]+\.x' | cut -d '/' -f3 | sort -r | head -n1)
fi
if [ $(/containsLabel $GITHUB_EVENT_PATH "target: minor") == "true" ]; then
  MINOR_BRANCH=$(git ls-remote --heads upstream | grep -E 'refs\/heads\/[0-9]+\.x' | cut -d '/' -f3 | sort -r | head -n1)
fi
if [ $(/containsLabel $GITHUB_EVENT_PATH "target: major") == "true" ]; then
  MAJOR_BRANCH="master"
fi

cd "$GITHUB_WORKSPACE";

if [ -n "$PATCH_BRANCH"]; then

fi
git checkout master;

curl -L -s $DIFF_URL > /tmp/pr.diff;

git apply --check /tmp/pr.diff 2>&1;
if [ $? -eq 0 ]; then
  result=true;
fi

# Communicate the result of the check via the exit code.
if [ "$result" = "true" ]; then
  exit 0;
else
  exit 1;
fi