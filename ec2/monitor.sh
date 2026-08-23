#!/usr/bin/env bash
set -euo pipefail

: "${AWS_REGION:?Set AWS_REGION first.}"
: "${EC2_INSTANCE_ID:?Set EC2_INSTANCE_ID first.}"

command -v aws >/dev/null 2>&1 || {
  echo "Error: AWS CLI is not installed."
  exit 1
}

aws ec2 describe-instances   --region "$AWS_REGION"   --instance-ids "$EC2_INSTANCE_ID"   --query 'Reservations[0].Instances[0].{
    InstanceId:InstanceId,
    State:State.Name,
    InstanceType:InstanceType,
    PrivateIp:PrivateIpAddress,
    PublicIp:PublicIpAddress,
    LaunchTime:LaunchTime
  }'   --output table
