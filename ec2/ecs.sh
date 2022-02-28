#!/bin/bash
# simple shell script to demonstrate how EC2 Instance Connect CLI is implemented.
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstances.html
#
# Usage
# $ bash ecs.sh brandon


############################################################
############################################################
# Help			                                           #
############################################################
############################################################

bold=$(tput bold)
normal=$(tput sgr0)

while getopts ":h" option; do
  case $option in
	h) # display Help
		echo "-----------------------------------------------------------"
		echo "| "
		echo "| ${bold}ECS Connect${normal}"
		echo "| ecs [SERVICE] [CLUSTER (optional)] [PROFILE (profile)]"
		echo "| "
		echo "| For example:"
		echo "| ecs-console brandonbest"
		echo "| OR"
		echo "| ecs-console brandonbest dev brandon"
		echo "| "
		echo "-----------------------------------------------------------"
		echo ""
		echo "${bold}Profiles${normal}"
		echo ""
		exit;;
  esac
done


############################################################
############################################################
# OPTOINS		                                           #
############################################################
############################################################

SERVICE=$1
CLUSTER=$2
PROFILE=$3

if [ -z "$CLUSTER" ]; then
  echo ""
  echo "Cluster not specified, defaulting to apps-stage"
  echo ""

  CLUSTER="apps-stage"
fi

if [ -z "$SERVICE" ]; then
  echo "-----------------------------------------------------------"
  echo ""
  echo "ERROR: Please Specify a Sevice"
  echo "ecs-console [SERVICE] [CLUSTER (optional)] [PROFILE (profile)]"
  echo ""
  echo "For example:"
  echo "ecs-console webapp"
  echo "OR"
  echo "ecs-console webapp apps-stage"
  echo ""
  echo "-----------------------------------------------------------"
  exit 1
fi

if [ -z "$PROFILE" ]; then
  echo ""
  echo "Profile not specified, defaulting to brandon"
  echo ""

  PROFILE="brandon"
fi


############################################################
############################################################
# Main program                                             #
############################################################
############################################################

# get EC2 data
TASK_ID=$( aws ecs list-tasks --profile $PROFILE --cluster=$CLUSTER --service-name=$SERVICE --output json | jq -r '.taskArns[0]' )
CONTAINER_INSTANCE_ID=$( aws ecs describe-tasks --profile $PROFILE --cluster=$CLUSTER --tasks $TASK_ID --output json | jq -r '.tasks[0].containerInstanceArn' )
EC2_INSTANCE=$( aws ecs describe-container-instances --profile $PROFILE --cluster=$CLUSTER --container-instances $CONTAINER_INSTANCE_ID --output json | jq -r '.containerInstances[0].ec2InstanceId' )
EC2_IP=$( aws ec2 describe-instances --instance-ids $EC2_INSTANCE --profile $PROFILE --output json | jq -r '.Reservations[0].Instances[0].PublicIpAddress' )
AVAILABILITY_ZONE=$(aws ec2 describe-instances --profile $PROFILE --instance-ids $EC2_INSTANCE | jq -r .Reservations[0].Instances[0].Placement.AvailabilityZone)

echo "---------------------------------------------------------------------------"
echo "|"
echo "| Connecting to AWS EC2 Instance: " $CONTAINER_INSTANCE_ID
echo "| On Availability Zone: " $AVAILABILITY_ZONE
echo "| IP: " $EC2_IP
echo "|"
echo "---------------------------------------------------------------------------"
echo ""

# generate RSA key pair
tmpfile=$(mktemp /tmp/ssh.XXXXXX)
ssh-keygen -C "eic temp key" -q -f $tmpfile -t rsa -b 2048 -N "" <<<y 2>&1 >/dev/null
PUBLIC_KEY=${tmpfile}.pub
PRIVATE_KEY=$tmpfile

# register public key
aws ec2-instance-connect send-ssh-public-key \
  --instance-id  $EC2_INSTANCE \
  --instance-os-user ec2-user \
  --ssh-public-key file://$PUBLIC_KEY \
  --availability-zone $AVAILABILITY_ZONE \
  --profile $PROFILE

# SSH Into the Container
echo "ssh -v -i " $PRIVATE_KEY "ec2-user@"$EC2_IP
ssh -v -i $PRIVATE_KEY ec2-user@$EC2_IP -t 'bash -c "docker exec -it $( docker ps -a -q -f name=ecs-'$SERVICE' | head -n 1 ) bash"'
