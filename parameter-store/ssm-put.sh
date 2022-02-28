#!/bin/bash
# simple shell script to demonstrate how EC2 Instance Connect CLI is implemented.
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstances.html
#
# Usage
# $ ssm-put

OVERWRITE=""

############################################################
############################################################
# Help			                                           #
############################################################
############################################################

bold=$(tput bold)
normal=$(tput sgr0)

while [ -n "$1" ]; do
  case "$1" in
	-h) # display Help
		echo ""
		echo "-----------------------------------------------------------"
		echo "| "
		echo "| ${bold}AWS Parameter Store Put${normal}"
		echo "| ssm-put [KEY] [VALUE] [PROFILE (optional)]"
		echo "| "
		echo "| For example:"
		echo "| ssm-put /beta/brandonbest https://api.brandonbest.com"
		echo "| "
		echo "-----------------------------------------------------------"
		echo ""
		echo "${bold}Profiles${normal}"
		echo ""
		echo ""
		exit;;
	-o) #Overwrite
		echo ""
		echo "Will Overwrite existing value"
		echo ""
		OVERWRITE=" --overwrite "
		;;
	*)
		break
		;;
  esac
  shift
done


############################################################
############################################################
# Pull Parameters
############################################################
############################################################

total=1

for param in $@; do
	total=$(($total + 1))
done


############################################################
############################################################
# Options
############################################################
############################################################

KEY=$1
VALUE=$2
PROFILE=$3

if [ -z "$KEY" ]; then
  echo "-----------------------------------------------------------"
  echo ""
  echo "ERROR: Please Specify a Key"
  echo "ssm-put [KEY] [VALUE] [PROFILE (optional)]"
  echo ""
  echo "For example:"
  echo "ssm-put /beta/brandonbest https://api.brandonbest.com"
  echo ""
  echo "-----------------------------------------------------------"
  exit 1
fi

if [ -z "$VALUE" ]; then
  echo "-----------------------------------------------------------"
  echo ""
  echo "ERROR: Please Specify a Value"
  echo "ssm-put [KEY] [VALUE] [PROFILE (optional)]"
  echo ""
  echo "For example:"
  echo "ssm-put /beta/brandonbest https://api.brandonbest.com"
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

echo "aws ssm put-parameter \
  --name $KEY \
  --value $VALUE \
  --type String \
  --profile $PROFILE $OVERWRITE"

aws ssm put-parameter \
  --name $KEY \
  --value $VALUE \
  --type String \
  --profile $PROFILE $OVERWRITE
