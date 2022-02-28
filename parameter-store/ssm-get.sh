#!/bin/bash
# simple shell script to demonstrate how EC2 Instance Connect CLI is implemented.
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstances.html
#
# Usage
# $ ssm-get

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
		echo "| ${bold}AWS Parameter Store Get${normal}"
		echo "| ssm-get [KEY] [PROFILE (optional)]"
		echo "| "
		echo "| For example:"
		echo "| ssm-get /beta/brandonbest"
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

KEY=$1
PROFILE=$2

if [ -z "$KEY" ]; then
  echo "-----------------------------------------------------------"
  echo ""
  echo "ERROR: Please Specify a Key"
  echo "fargate [KEY] [PROFILE (optional)]"
  echo ""
  echo "For example:"
  echo "ssm-get /beta/branodnbest"
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

echo "aws ssm get-parameter \
  --name $KEY \
  --profile $PROFILE"

aws ssm get-parameter \
  --name $KEY \
  --profile $PROFILE
