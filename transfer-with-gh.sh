#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

# Check required environment variables
if [ -z "$SOURCE_REPO" ] || [ -z "$DEST_REPO" ]; then
  echo "Error: SOURCE_REPO and DEST_REPO must be set in .env file"
  echo "Please copy .env.sample to .env and fill in the values"
  exit 1
fi

LOG_DIR="./gh-transfer-logs"

mkdir -p "$LOG_DIR"

# Get all open issues (excluding PRs)
echo "Fetching open issues from $SOURCE_REPO..."
issues=$(gh issue list --repo "$SOURCE_REPO" --state open --limit 1000 --json number,title --jq '.[] | @text "\(.number)|\(.title)"')

total=$(echo "$issues" | wc -l | tr -d ' ')
echo "Found $total open issues to transfer"

count=0
success=0
failed=0

while IFS='|' read -r number title; do
  count=$((count + 1))
  echo "[$count/$total] Transferring #$number: $title"

  if gh issue transfer "$number" "$DEST_REPO" --repo "$SOURCE_REPO" >> "$LOG_DIR/success.log" 2>&1; then
    echo "  ✓ Success"
    echo "$number|$title" >> "$LOG_DIR/transferred.txt"
    success=$((success + 1))
  else
    echo "  ✗ Failed"
    echo "$number|$title" >> "$LOG_DIR/failed.txt"
    failed=$((failed + 1))
  fi

  # Small delay to avoid rate limiting
  sleep 0.5
done <<< "$issues"

echo ""
echo "Transfer complete!"
echo "Success: $success"
echo "Failed: $failed"
echo "Logs saved in: $LOG_DIR"
