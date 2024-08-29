#!/bin/bash
usage() { echo "Usage: $0 [-c <cluster-name>] [-a <assume-role>]" 1>&2; exit 1; }

while getopts ":c:a:" o; do
    case "${o}" in
        c)
            CLUSTER=${OPTARG}
            ;;
        a)
            ASSUME_ROLE_ARN=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${CLUSTER}" ]; then
    usage
fi

if [ ! -z "$ASSUME_ROLE_ARN" ]; then
  temp_role=$(aws sts assume-role \
      --role-arn $ASSUME_ROLE_ARN \
      --role-session-name temp)

  export AWS_ACCESS_KEY_ID=$(echo $temp_role | jq -r .Credentials.AccessKeyId)
  export AWS_SECRET_ACCESS_KEY=$(echo $temp_role | jq -r .Credentials.SecretAccessKey)
  export AWS_SESSION_TOKEN=$(echo $temp_role | jq -r .Credentials.SessionToken)

  aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
  aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
  aws configure set aws_session_token $AWS_SESSION_TOKEN 
fi


# Get a list of all the instances in the node group
comm=`printf "aws ec2 describe-instances --query 'Reservations[*].Instances[*].InstanceId' --filters "Name=tag-key,Values=eks:cluster-name" "Name=tag-value,Values=$CLUSTER" --output text"`
INSTANCE_IDS=(`eval $comm`)
target=$(kubectl get nodes | grep Read | wc -l)
# iterate through nodes - terminate one at a time
for i in "${INSTANCE_IDS[@]}"
do
curr=0
echo "Terminating EC2 instance $i ... "
aws ec2 terminate-instances --instance-ids $i | jq -r .TerminatingInstances[0].CurrentState.Name
while [ $curr -ne $target ]; do
    stat=$(aws ec2 describe-instance-status --instance-ids $i  --include-all-instances | jq -r .InstanceStatuses[0].InstanceState.Name)
    
    if [ "$stat" == "terminated" ]; then
        sleep 15
        curr=$(kubectl get nodes | grep -v NotReady | grep Read | wc -l)
        kubectl get nodes
        echo "Current Ready nodes = $curr of $target"
    fi
    if [ "$stat" != "terminated" ]; then
        sleep 10
        echo "$i $stat"
    fi
done
done
echo "done"