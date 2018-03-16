#!/bin/bash
# a sample bash_profile containing the profile function
# which will add the current aws profile name to your bash prompt
#
# This script assumes the repo is being checked out into ~/DevOps/cloud-stuff

export PATH=$PATH:/opt/terraform
export PS1="\D{%F %T} [\u@\h:\W] ($AWS_PROFILE)$ "

profile() {
    . ~/DevOps/cloud-stuff/profile.sh $1
    export PS1="\D{%F %T} [\u@\h:\W] ($AWS_PROFILE)$ "
}
