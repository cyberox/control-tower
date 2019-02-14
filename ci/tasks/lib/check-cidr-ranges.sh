#!/bin/bash

function assertNetworkCidrsCorrect() {
  echo "About to check network CIDR ranges"

  expected_public_cidr=${1:-"10.0.0.0/24"}
  expected_private_cidr=${2:-"10.0.1.0/24"}
  expected_vpc_cidr=${3:-"10.0.0.0/16"}
  region=${4:-""}

  if [ "$IAAS" = "AWS" ]; then
    if [ -z "$region" ]; then
        region="eu-west-1"
    fi
    vpc_cidr="$(aws --region "$region" ec2 describe-vpcs --filters "Name=tag:concourse-up-project,Values=${deployment}" | jq -r ".Vpcs[0].CidrBlock")"
    if [ "$vpc_cidr" != "$expected_vpc_cidr" ]; then
      echo "Unexpected VPC CIDR: $vpc_cidr"
      exit 1
    fi

    public_cidr="$(aws --region "$region" ec2 describe-subnets --filters "Name=tag:Name,Values=concourse-up-${deployment}-public" | jq -r ".Subnets[0].CidrBlock")"
    if [ "$public_cidr" != "$expected_public_cidr" ]; then
      echo "Unexpected public subnet CIDR: $public_cidr"
      exit 1
    fi

    private_cidr="$(aws --region "$region" ec2 describe-subnets --filters "Name=tag:Name,Values=concourse-up-${deployment}-private" | jq -r ".Subnets[0].CidrBlock")"
    if [ "$private_cidr" != "$expected_private_cidr" ]; then
      echo "Unexpected private subnet CIDR: $private_cidr"
      exit 1
    fi

  elif [ "$IAAS" = "GCP" ]; then
    if [ -z "$region" ]; then
        region="europe-west1"
    fi
    public_cidr="$(gcloud compute networks subnets describe "concourse-up-${deployment}-${region}-public" --region "$region" --format json | jq -r ".ipCidrRange")"
    if [ "$public_cidr" != "$expected_public_cidr" ]; then
      echo "Unexpected public subnet CIDR: $public_cidr"
      exit 1
    fi

    private_cidr="$(gcloud compute networks subnets describe "concourse-up-${deployment}-${region}-private" --region "$region" --format json | jq -r ".ipCidrRange")"
    if [ "$private_cidr" != "$expected_private_cidr" ]; then
      echo "Unexpected private subnet CIDR: $private_cidr"
      exit 1
    fi
  else
    echo "Unknown iaas: $IAAS"
    exit 1
  fi

  echo "Network CIDR ranges correct"
}
