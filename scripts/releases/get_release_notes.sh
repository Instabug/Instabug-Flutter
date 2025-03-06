latest_release=""
capturing=false

while IFS= read -r line; do
  if [[ "$line" == "## ["* ]]; then
      # If we are already capturing, this means we have reached the next release section.
      if $capturing; then
        break  # stop reading further
      fi
      # Otherwise, this is the start of the latest release section.
      capturing=true
  fi

  # If capturing is enabled, append the current line to our release notes variable.
  if $capturing; then
    latest_release+="$line"$'\n'
  fi
done < CHANGELOG.md

latest_release=$(tail -n +3 <<< "$latest_release")
latest_release=$(./scripts/releases/changelog_to_slack_formatter.sh <<< "$latest_release")

echo "$latest_release"