export PATH=$PATH:/opt/terraform
export PS1="\u@lappy:\W [$AWS_PROFILE] $ "

profile() {
    . ~/DevOps/cloud-stuff/profile.sh $1
    export PS1="\u@lappy:\W [$AWS_PROFILE] $ "
}
