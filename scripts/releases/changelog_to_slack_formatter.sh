#!/bin/bash
# changelog_to_slack_formatter.sh: Convert Markdown changelog to Slack mrkdwn format
# Supports input from a file or STDIN.

# If an input file is provided as an argument, read from it.
# Otherwise, read from STDIN.
if [ $# -eq 1 ]; then
  if [ ! -f "$1" ]; then
    echo "Error: File '$1' not found!" >&2
    exit 1
  fi
  input=$(cat "$1")
else
  input=$(cat)
fi

# Process the input using sed:
# 1. Convert Markdown links: [text](url) -> <url|text>
# 2. Convert header lines (e.g., '## Title') to bold by removing '#' and wrapping text in asterisks.
# 3. Convert bullet lists: '- ' -> '• '
echo "$input" | sed -E \
  -e 's/\[([^]]+)\]\(([^)]+)\)/<\2|\1>/g' \
  -e 's/^#{1,6}[[:space:]]*([^[:space:]].*)$/\*\1\*/' \
  -e 's/^- /• /'