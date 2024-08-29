# Script creates a list of Security Groups without Network Interfaces and redirects the output to a file.
# You can add "aws ec2 delete-security-group --group-id $i" in the loop to automatically delete the security groups. Be careful with this.

echo '# Security Groups without Network Interfaces:' >> unused_sg.txt
for i in $(aws ec2 describe-security-groups --query "SecurityGroups[*].{ID:GroupId}" --output text); do
    if [[ $(aws ec2 describe-network-interfaces --filters Name=group-id,Values=$i --output yaml) = 'NetworkInterfaces: []' ]]; then
        echo $i >> unused_sg.txt
    fi
done
