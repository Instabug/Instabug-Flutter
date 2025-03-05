jobsJson=$(curl -X GET "https://circleci.com/api/v2/workflow/ea620bb8-4219-4815-a5b2-21d11357418c/job" --header "Circle-Token: $CIRCLE_TOKEN")
job=$(jq '.items[] | select(.name == "hold_release_slack_notification")' <<< "$jobsJson")

approver_id=$(jq '.approved_by' <<< "$job")
approver_id=$(echo "$approver_id" | tr -d '"')

user=$(curl -s -f -X GET "https://circleci.com/api/v2/user/$approver_id" -u "$CIRCLE_TOKEN":)

username=$(jq '.login' <<< "$user")
username=$(echo "$username" | tr -d '"')

slack_id=$(./scripts/releases/get_slack_id_from_username.sh "$username")

echo "$slack_id"