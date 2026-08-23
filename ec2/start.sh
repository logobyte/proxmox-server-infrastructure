#!/usr/bin/env bash
set -euo pipefail

: "${AWS_REGION:?Set AWS_REGION first.}"
: "${EC2_INSTANCE_ID:?Set EC2_INSTANCE_ID first.}"

command -v aws >/dev/null 2>&1 || {
  echo "Error: AWS CLI is not installed."
  exit 1
}

state="$(
  aws ec2 describe-instances     --region "$AWS_REGION"     --instance-ids "$EC2_INSTANCE_ID"     --query 'Reservations[0].Instances[0].State.Name'     --output text
)"

echo "Current state: $state"

case "$state" in
  stopped)
    echo "Starting EC2 instance $EC2_INSTANCE_ID..."
    aws ec2 start-instances       --region "$AWS_REGION"       --instance-ids "$EC2_INSTANCE_ID" >/dev/null
    echo "Start request submitted."
    ;;
  running|pending)
    echo "Instance is already running or starting. No action taken."
    ;;
  *)
    echo "Instance is in state '$state'. No automatic action taken."
    ;;
esac
