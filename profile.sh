#!/bin/bash

# a script to more easily switch between aws profiles on the cli
# combine with bash_profile in this repository to make life less dumb

PROFILE=$1

if [ -z $PROFILE ]; then
    echo "Error: a profile argument must be supplied"
else
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    unset AWS_DEFAULT_REGION
    unset AWS_PROFILE

    ACCESS=$(aws configure get aws_access_key_id --profile $PROFILE 2>/dev/null)
    SECRET=$(aws configure get aws_secret_access_key --profile $PROFILE 2>/dev/null)
    REGION=$(aws configure get region --profile $PROFILE 2>/dev/null)
    MFA_DEVICE=$(aws configure get mfa_device --profile $PROFILE 2>/dev/null)

    if [ -z $ACCESS ] || [ -z $SECRET ]; then
        echo "Error: $PROFILE does not exist or is missing info in ~/.aws/credentials"
        exit
    else
        export AWS_ACCESS_KEY_ID=$ACCESS
        export AWS_SECRET_ACCESS_KEY=$SECRET
        export AWS_DEFAULT_REGION=$REGION
        export AWS_PROFILE=$PROFILE
    fi

    if [ -n $MFA_DEVICE ]; then
        echo -n "MFA Token: "
        read TOKEN_CODE
        STS_SESSION=$(aws sts get-session-token --serial-number $MFA_DEVICE --token-code $TOKEN_CODE)
        export AWS_ACCESS_KEY_ID=$(echo $STS_SESSION | jq -r '.Credentials.AccessKeyId')
        export AWS_SECRET_ACCESS_KEY=$(echo $STS_SESSION | jq -r '.Credentials.SecretAccessKey')
        export AWS_SESSION_TOKEN=$(echo $STS_SESSION | jq -r '.Credentials.SessionToken')
    fi
fi
