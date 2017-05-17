#!/bin/bash

# a script to more easily switch between aws profiles on the cli
# combine with bash_profile in this repository to make life less dumb

PROFILE=$1

if [ -z $PROFILE ]; then
    echo "Error: a profile argument must be supplied"
else
    ACCESS=$(aws configure get aws_access_key_id --profile $PROFILE 2>/dev/null)
    SECRET=$(aws configure get aws_secret_access_key --profile $PROFILE 2>/dev/null)
    REGION=$(aws configure get region --profile $PROFILE 2>/dev/null)

    if [ -z $ACCESS ] || [ -z $SECRET ] || [ -z $REGION ]; then
        echo "Error: $PROFILE does not exist or is missing info in ~/.aws/credentials"
    else
        export AWS_ACCESS_KEY_ID=$ACCESS
        export AWS_SECRET_ACCESS_KEY=$SECRET
        export AWS_DEFAULT_REGION=$REGION
	export AWS_PROFILE=$PROFILE
    fi
fi

