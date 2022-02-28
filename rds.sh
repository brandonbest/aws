#!/bin/bash
# Shell script to connect to RDS
#
# Usage
# $ bash rds.sh <profile> <db cluster>

PROFILE=$1
DB_CLUSTER=$1

if [ -z "$PROFILE" ]; then
  echo ""
  echo "Profile not specified, defaulting to brandon"
  echo ""

  PROFILE="brandon"
fi

if [ -z "$DB_CLUSTER" ]; then
  echo ""
  echo "DB Cluster not specified. Please try again."
  echo ""

  exit 1
fi


# Pull Instance ID
INSTANCE=$( aws ec2 describe-instances --filters "Name=tag:Name,Values=ssh-tunnel" --profile $PROFILE --output json )
INSTANCE_ID=$( aws ec2 describe-instances --filters "Name=tag:Name,Values=ssh-tunnel" --profile $PROFILE --output json | jq -r '.Reservations[0].Instances[0].InstanceId' )
INSTANCE_IP=$( aws ec2 describe-instances --filters "Name=tag:Name,Values=ssh-tunnel" --profile $PROFILE --output json | jq -r '.Reservations[0].Instances[0].PublicIpAddress' )
AZ=$( aws ec2 describe-instances --filters "Name=tag:Name,Values=ssh-tunnel" --profile $PROFILE --output json | jq -r '.Reservations[0].Instances[0].Placement.AvailabilityZone')


# Push SSH Key into Instance
aws ec2-instance-connect send-ssh-public-key \
	--instance-id $INSTANCE_ID \
	--instance-os-user ec2-user \
	--ssh-public-key file://~/.ssh/id_rsa.pub \
	--availability-zone $AZ \
	--profile $PROFILE
                       
                       
# Pull RDS Instance
RDS_INSTANCE=$( aws rds describe-db-instances --profile $PROFILE --filters Name=db-cluster-id,Values=$DB_CLUSTER --output json | jq -r '.DBInstances[0].Endpoint.Address' )
RDS_PORT=$( aws rds describe-db-instances --profile $PROFILE --filters Name=db-cluster-id,Values=$DB_CLUSTER --output json | jq -r '.DBInstances[0].Endpoint.Port' )

#ssh ec2-user@$INSTANCE_IP -L $RDS_PORT:$RDS_INSTANCE:$RDS_PORT
echo ""
echo "Command Line SSH:"
echo "ssh ec2-user@"$INSTANCE_IP" -L "$RDS_PORT":"$RDS_INSTANCE":"$RDS_PORT

echo ""
echo "Tunnel User: ec2-user"
echo "Tunnel IP: $INSTANCE_IP"
echo ""
