#!/bin/bash

# Exit on error
set -e

# Function to check command status
check_status() {
    if [ $? -eq 0 ]; then
        echo "✅ $1 successful"
    else
        echo "❌ $1 failed"
        exit 1
    fi
}

echo "🚀 Starting VPC setup for RDS..."

# Create VPC
VPC_ID=$(aws ec2 create-vpc \
    --cidr-block 10.0.0.0/16 \
    --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=library-vpc}]' \
    --query 'Vpc.VpcId' \
    --output text)
check_status "VPC creation"

# Enable DNS hostnames
aws ec2 modify-vpc-attribute \
    --vpc-id $VPC_ID \
    --enable-dns-hostnames "{\"Value\":true}"
check_status "Enable DNS hostnames"

# Create Internet Gateway
IGW_ID=$(aws ec2 create-internet-gateway \
    --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=library-igw}]' \
    --query 'InternetGateway.InternetGatewayId' \
    --output text)
check_status "Internet Gateway creation"

# Attach Internet Gateway to VPC
aws ec2 attach-internet-gateway \
    --vpc-id $VPC_ID \
    --internet-gateway-id $IGW_ID
check_status "Internet Gateway attachment"

# Create public subnets in different AZs
PUBLIC_SUBNET_1_ID=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block 10.0.1.0/24 \
    --availability-zone us-east-1a \
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=library-public-1}]' \
    --query 'Subnet.SubnetId' \
    --output text)
check_status "Public subnet 1 creation"

PUBLIC_SUBNET_2_ID=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block 10.0.2.0/24 \
    --availability-zone us-east-1b \
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=library-public-2}]' \
    --query 'Subnet.SubnetId' \
    --output text)
check_status "Public subnet 2 creation"

# Create private subnets for RDS
PRIVATE_SUBNET_1_ID=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block 10.0.3.0/24 \
    --availability-zone us-east-1a \
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=library-private-1}]' \
    --query 'Subnet.SubnetId' \
    --output text)
check_status "Private subnet 1 creation"

PRIVATE_SUBNET_2_ID=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block 10.0.4.0/24 \
    --availability-zone us-east-1b \
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=library-private-2}]' \
    --query 'Subnet.SubnetId' \
    --output text)
check_status "Private subnet 2 creation"

# Create public route table
PUBLIC_RT_ID=$(aws ec2 create-route-table \
    --vpc-id $VPC_ID \
    --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=library-public-rt}]' \
    --query 'RouteTable.RouteTableId' \
    --output text)
check_status "Public route table creation"

# Create route to Internet Gateway
aws ec2 create-route \
    --route-table-id $PUBLIC_RT_ID \
    --destination-cidr-block 0.0.0.0/0 \
    --gateway-id $IGW_ID
check_status "Public route creation"

# Associate public subnets with public route table
aws ec2 associate-route-table \
    --subnet-id $PUBLIC_SUBNET_1_ID \
    --route-table-id $PUBLIC_RT_ID
aws ec2 associate-route-table \
    --subnet-id $PUBLIC_SUBNET_2_ID \
    --route-table-id $PUBLIC_RT_ID
check_status "Public route table association"

# Create DB subnet group
aws rds create-db-subnet-group \
    --db-subnet-group-name library-db-subnet-group \
    --db-subnet-group-description "Subnet group for Library RDS" \
    --subnet-ids "$PRIVATE_SUBNET_1_ID" "$PRIVATE_SUBNET_2_ID" \
    --tags 'Key=Name,Value=library-db-subnet-group'
check_status "DB subnet group creation"

# Create security group for RDS
SECURITY_GROUP_ID=$(aws ec2 create-security-group \
    --group-name library-rds-sg \
    --description "Security group for Library RDS" \
    --vpc-id $VPC_ID \
    --query 'GroupId' \
    --output text)
check_status "Security group creation"

# Add inbound rule for MySQL (3306)
aws ec2 authorize-security-group-ingress \
    --group-id $SECURITY_GROUP_ID \
    --protocol tcp \
    --port 3306 \
    --cidr 10.0.0.0/16
check_status "Security group rule creation"

echo "
✅ VPC setup completed successfully!

VPC Details:
-----------------
VPC ID: $VPC_ID
Public Subnet 1 ID: $PUBLIC_SUBNET_1_ID
Public Subnet 2 ID: $PUBLIC_SUBNET_2_ID
Private Subnet 1 ID: $PRIVATE_SUBNET_1_ID
Private Subnet 2 ID: $PRIVATE_SUBNET_2_ID
Security Group ID: $SECURITY_GROUP_ID
DB Subnet Group: library-db-subnet-group

Use these IDs in your RDS deployment script.
"

# Save details to a file
cat > vpc-details.txt << EOF
VPC_ID=$VPC_ID
PUBLIC_SUBNET_1_ID=$PUBLIC_SUBNET_1_ID
PUBLIC_SUBNET_2_ID=$PUBLIC_SUBNET_2_ID
PRIVATE_SUBNET_1_ID=$PRIVATE_SUBNET_1_ID
PRIVATE_SUBNET_2_ID=$PRIVATE_SUBNET_2_ID
SECURITY_GROUP_ID=$SECURITY_GROUP_ID
DB_SUBNET_GROUP=library-db-subnet-group
EOF

echo "Details saved to vpc-details.txt"