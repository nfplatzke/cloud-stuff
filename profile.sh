#!/bin/bash
  
# a script to more easily switch between aws profiles on the cli
# combine with bash_profile in this repository to make life less dumb

PROFILE=$1

if [ -z $PROFILE ]; then
    echo "Error: a profile argument must be supplied"
else
    REGION=$(aws configure get region --profile $PROFILE 2>/dev/null)
    MFA_DEVICE=$(aws configure get mfa_device --profile $PROFILE 2>/dev/null)

    if [ -n $MFA_DEVICE ]; then
        echo -n "MFA Token: "
        read TOKEN_CODE
        STS_SESSION=$(aws sts get-session-token --serial-number $MFA_DEVICE --token-code $TOKEN_CODE)
        ACCESS=$(echo $STS_SESSION | jq -r '.Credentials.AccessKeyId')
        SECRET=$(echo $STS_SESSION | jq -r '.Credentials.SecretAccessKey')
        SESSION=$(echo $STS_SESSION | jq -r '.Credentials.SessionToken')
    else
        ACCESS=$(aws configure get aws_access_key_id --profile $PROFILE 2>/dev/null)
        SECRET=$(aws configure get aws_secret_access_key --profile $PROFILE 2>/dev/null)
    fi

    if [ -z $ACCESS ] || [ -z $SECRET ]; then
        echo "Error: $PROFILE does not exist or is missing info in ~/.aws/credentials"
    else
        export AWS_ACCESS_KEY_ID=$ACCESS
        export AWS_SECRET_ACCESS_KEY=$SECRET

        if [ -n $SESSION ]; then
            export AWS_SESSION_TOKEN=$SESSION
        fi

        export AWS_DEFAULT_REGION=$REGION
        export AWS_PROFILE=$PROFILE
    fi
fi

