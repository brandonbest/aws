#!/bin/bash
# simple shell script to demonstrate how EC2 Instance Connect CLI is implemented.
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstances.html
#
# Usage
# $ bash fargate.sh webapp

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
		echo ""
		echo "-----------------------------------------------------------"
		echo "| "
		echo "| ${bold}Fargate Connect${normal}"
		echo "| fargate [SERVICE] [CLUSTER (optional)] [PROFILE (profile)]"
		echo "| "
		echo "| For example:"
		echo "| fargate brandonbest"
		echo "| OR"
		echo "| fargate webapp apps-stage <profile>"
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
# Options			                                           #
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
  echo "fargate [SERVICE] [CLUSTER (optional)] [PROFILE (optional)]"
  echo ""
  echo "For example:"
  echo "fargate webapp"
  echo "OR"
  echo "fargate bisreach apps-stage"
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

# get Fargate data
TASK_IDS=$( aws ecs list-tasks --cluster=$CLUSTER --profile $PROFILE --service-name=$SERVICE --output json | jq -r '.taskArns[0]' )

IFS='/' read -ra TASK_ID_ARRAY <<< "$TASK_IDS"
TASK_ID=${TASK_ID_ARRAY[2]}

CONTAINER=$( aws ecs describe-tasks --profile $PROFILE --cluster=$CLUSTER --tasks $TASK_ID | jq -r '.tasks[0].containers[0].name' )

echo "---------------------------------------------------------------------------"
echo "|"
echo "| Connecting to AWS Fargate Instance: " $SERVICE
echo "| Task ID: " $TASK_ID
echo "| Cluster: " $CLUSTER
echo "| Container: " $CONTAINER
echo "|"
echo "---------------------------------------------------------------------------"
echo ""

echo "aws ecs execute-command \
  --region us-east-1 \
  --cluster $CLUSTER \
  --task $TASK_ID \
  --container $CONTAINER \
  --command \"/bin/bash\" \
  --interactive \
  --profile $PROFILE"

# Connect to the Task
aws ecs execute-command \
  --region us-east-1 \
  --cluster $CLUSTER \
  --task $TASK_ID \
  --container $CONTAINER \
  --command "/bin/bash" \
  --interactive \
  --profile $PROFILE
