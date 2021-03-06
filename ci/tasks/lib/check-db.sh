#!/bin/bash

function assertDbCorrect() {
  if [ "$IAAS" = "AWS" ]; then
  echo "About to check DB class"
  rds_instance_class=$(aws --region eu-west-1 rds describe-db-instances | jq -r ".DBInstances[] | select(.DBSubnetGroup.DBSubnetGroupName==\"control-tower-$deployment\") | .DBInstanceClass")
    if [ "$rds_instance_class" != "db.t3.small" ]; then
      echo "Unexpected DB instance class: $rds_instance_class"
      exit 1
    fi
    echo "DB class correct"
  elif [ "$IAAS" = "GCP" ]; then
    echo "About to check DB tier"
    rds_instance_tier=$(gcloud sql instances list --filter="labels.deployment:control-tower-$deployment" --format=json | jq -r '.[0].settings.tier')
    if [ "$rds_instance_tier" != "db-g1-small" ]; then
      echo "Unexpected DB instance tier: $rds_instance_tier"
      exit 1
    fi
    echo "DB instance tier correct"
    else
      echo "Unknown iaas: $IAAS"
      exit 1
  fi
}
