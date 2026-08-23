#!/usr/bin/env bash
set -euo pipefail

: "${AWS_REGION:?Set AWS_REGION first.}"
: "${S3_BUCKET_NAME:?Set S3_BUCKET_NAME first.}"
: "${LOCAL_BACKUP_DIR:?Set LOCAL_BACKUP_DIR first.}"

command -v aws >/dev/null 2>&1 || {
  echo "Error: AWS CLI is not installed."
  exit 1
}

if [[ ! -d "$LOCAL_BACKUP_DIR" ]]; then
  echo "Error: Local directory does not exist: $LOCAL_BACKUP_DIR"
  exit 1
fi

if [[ "${APPLY_SYNC:-no}" == "yes" ]]; then
  echo "Applying S3 sync..."
  aws s3 sync     "$LOCAL_BACKUP_DIR"     "s3://$S3_BUCKET_NAME/sync/"     --region "$AWS_REGION"
else
  echo "Dry run only. No S3 files will be changed."
  aws s3 sync     "$LOCAL_BACKUP_DIR"     "s3://$S3_BUCKET_NAME/sync/"     --region "$AWS_REGION"     --dryrun
  echo "Run with APPLY_SYNC=yes to perform the actual sync."
fi
