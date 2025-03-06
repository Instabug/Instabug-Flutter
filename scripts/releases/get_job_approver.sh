echo "CIRCLE_WORKFLOW_ID: $CIRCLE_WORKFLOW_ID"
echo "CIRCLE_TOKEN: ${CIRCLE_TOKEN: -4}"  # (or at least echo if it's empty or not)

jobsJson=$(curl -v -X GET "https://circleci.com/api/v2/workflow/$CIRCLE_WORKFLOW_ID/job" --header "Circle-Token: $CIRCLE_TOKEN")

echo "jobsJson response:"
echo "$jobsJson"

job=$(jq '.items[] | select(.name == "hold_release_slack_notification")' <<< "$jobsJson")

echo "job:"
echo "$job"

approver_id=$(jq '.approved_by' <<< "$job")

echo "approver_id:"
echo "$approver_id"

approver_id=$(echo "$approver_id" | tr -d '"')

user=$(curl -v -X GET "https://circleci.com/api/v2/user/$approver_id" --header "Circle-Token: $CIRCLE_TOKEN")

echo "user:"
echo "$user"

username=$(jq '.login' <<< "$user")

echo "username:"
echo "$username"

username=$(echo "$username" | tr -d '"')

slack_id=$(./scripts/releases/get_slack_id_from_username.sh "$username")

echo "$slack_id"