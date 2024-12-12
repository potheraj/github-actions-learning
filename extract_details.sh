#!/bin/bash

# Read the issue body from github event path
ISSUE_BODY=$(jq -r 'issue.body' < "$GITHUB_EVENT_PATH")


extract_section() {
    echo "$ISSUE_BODY" | awk -v section="$1" '
        $0 ~ section {flag=1; next}
        /^### / {flag=0}
    '
}

DELIVERABLE_NAME=$(extract_section "### Deliverable Name" | tr -d '\n')
MAJOR_RELEASE=$(extract_section "### Is this a major release?" | tr -d '\n')

echo "Issue Body: $ISSUE_BODY"
echo "Deliverable Name: $DELIVERABLE_NAME"
echo "Major Release: $MAJOR_RELEASE"

echo "deliverable_name=$DELIVERABLE_NAME" >> $GITHUB_OUTPUT
echo "major_release=$MAJOR_RELEASE" >> $GITHUB_OUTPUT