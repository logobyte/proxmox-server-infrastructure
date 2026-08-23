#!/usr/bin/env bash
set -euo pipefail

: "${AWS_REGION:?Set AWS_REGION first.}"
: "${EC2_INSTANCE_ID:?Set EC2_INSTANCE_ID first.}"

command -v aws >/dev/null 2>&1 || {
  echo "Error: AWS CLI is not installed."
  exit 1
}

if [[ "${CONFIRM_STOP:-no}" != "yes" ]]; then
  echo "Safety check: EC2 stop was NOT performed."
  echo "Run with CONFIRM_STOP=yes to explicitly allow the stop request."
  exit 0
fi

state="$(
  aws ec2 describe-instances     --region "$AWS_REGION"     --instance-ids "$EC2_INSTANCE_ID"     --query 'Reservations[0].Instances[0].State.Name'     --output text
)"

echo "Current state: $state"

case "$state" in
  running)
    echo "Stopping EC2 instance $EC2_INSTANCE_ID..."
    aws ec2 stop-instances       --region "$AWS_REGION"       --instance-ids "$EC2_INSTANCE_ID" >/dev/null
    echo "Stop request submitted."
    ;;
  stopped|stopping)
    echo "Instance is already stopped or stopping. No action taken."
    ;;
  *)
    echo "Instance is in state '$state'. No automatic action taken."
    ;;
esac
