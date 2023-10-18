#!/bin/bash
# command ./env_aws_eks_vpc.sh stack_name
# eks version 1.26
stack_name=$1
echo stack_name: $stack_name

# Export VPC id
export vpc_ID=$(aws ec2 describe-vpcs --filters Name=tag:Name,Values=$stack_name | jq -r '.Vpcs[].VpcId')
echo vpc_id: $vpc_ID

# Export Subnet id, CIDR, Subnet Name
aws ec2 describe-subnets --filter Name=vpc-id,Values=$vpc_ID | jq -r '.Subnets[]|.SubnetId+" "+.CidrBlock+" "+(.Tags[]|select(.Key=="Name").Value)'
echo $vpc_ID > vpc_subnet.txt
aws ec2 describe-subnets --filter Name=vpc-id,Values=$vpc_ID | jq -r '.Subnets[]|.SubnetId+" "+.CidrBlock+" "+(.Tags[]|select(.Key=="Name").Value)' >> vpc_subnet.txt
cat vpc_subnet.txt

# Save environment variable for VPC, Subnet id
export PublicSubnet01=$(aws ec2 describe-subnets --filters 'Name=tag:Name,Values='"$stack_name"'-PublicSubnet01' | jq -r '.Subnets[].SubnetId')
export PublicSubnet02=$(aws ec2 describe-subnets --filters 'Name=tag:Name,Values='"$stack_name"'-PublicSubnet02' | jq -r '.Subnets[].SubnetId')
export PublicSubnet03=$(aws ec2 describe-subnets --filters 'Name=tag:Name,Values='"$stack_name"'-PublicSubnet03' | jq -r '.Subnets[].SubnetId')
export PrivateSubnet01=$(aws ec2 describe-subnets --filters 'Name=tag:Name,Values='"$stack_name"'-PrivateSubnet01' | jq -r '.Subnets[].SubnetId')
export PrivateSubnet02=$(aws ec2 describe-subnets --filters 'Name=tag:Name,Values='"$stack_name"'-PrivateSubnet02' | jq -r '.Subnets[].SubnetId')
export PrivateSubnet03=$(aws ec2 describe-subnets --filters 'Name=tag:Name,Values='"$stack_name"'-PrivateSubnet03' | jq -r '.Subnets[].SubnetId')
echo "export vpc_ID=${vpc_ID}" | tee -a ~/.bash_profile
echo "export PublicSubnet01=${PublicSubnet01}" | tee -a ~/.bash_profile
echo "export PublicSubnet02=${PublicSubnet02}" | tee -a ~/.bash_profile
echo "export PublicSubnet03=${PublicSubnet03}" | tee -a ~/.bash_profile
echo "export PrivateSubnet01=${PrivateSubnet01}" | tee -a ~/.bash_profile
echo "export PrivateSubnet02=${PrivateSubnet02}" | tee -a ~/.bash_profile
echo "export PrivateSubnet03=${PrivateSubnet03}" | tee -a ~/.bash_profile

# Create eks cluster environment 
export ekscluster_name=$stack_name
export eks_version="1.26"
export instance_type="m5.xlarge"
export public_selfmgmd_node="frontend-workloads"
export private_selfmgmd_node="backend-workloads"
export public_mgmd_node="managed-frontend-workloads"
export private_mgmd_node="managed-backend-workloads"
export publicKeyPath="/home/ec2-user/environment/$stack_name.pub"

echo ${ekscluster_name}
echo ${AWS_REGION}
echo ${eks_version}
echo ${PublicSubnet01}
echo ${PublicSubnet02}
echo ${PublicSubnet03}
echo ${PrivateSubnet01}
echo ${PrivateSubnet02}
echo ${PrivateSubnet03}
echo ${MASTER_ARN}
echo ${instance_type}
echo ${public_selfmgmd_node}
echo ${private_selfmgmd_node}
echo ${public_mgmd_node}
echo ${private_mgmd_node}
echo ${publicKeyPath}

# Save environment variable for ekscluster name, version, instance type, nodegroup label
echo "export ekscluster_name=${ekscluster_name}" | tee -a ~/.bash_profile
echo "export eks_version=${eks_version}" | tee -a ~/.bash_profile
echo "export instance_type=${instance_type}" | tee -a ~/.bash_profile
echo "export public_selfmgmd_node=${public_selfmgmd_node}" | tee -a ~/.bash_profile
echo "export private_selfmgmd_node=${private_selfmgmd_node}" | tee -a ~/.bash_profile
echo "export public_mgmd_node=${public_mgmd_node}" | tee -a ~/.bash_profile
echo "export private_mgmd_node=${private_mgmd_node}" | tee -a ~/.bash_profile
echo "export publicKeyPath=${publicKeyPath}" | tee -a ~/.bash_profile

source ~/.bash_profile

