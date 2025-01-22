#!/bin/bash

# Set variables
DB_INSTANCE_IDENTIFIER="library-db"
DB_CLASS="db.t3.micro"
ENGINE="mysql"
ENGINE_VERSION="8.0.32"
STORAGE_SIZE=20
MASTER_USERNAME="admin"
MASTER_PASSWORD="YourStrongPassword123!" # Change this!
VPC_SECURITY_GROUP_ID="sg-0a2b0af1ea24955f6" # Change this!
SUBNET_GROUP_NAME="library-db-subnet-group" # Change this!

# Create Security Group for RDS
#echo "Creating Security Group..."
#SECURITY_GROUP_ID=$(aws ec2 create-security-group \
#    --group-name rds-library-sg \
#    --description "Security group for Library RDS instance" \
#    --output text --query 'GroupId')

# Get your current IP address
MY_IP=$(curl -s http://checkip.amazonaws.com)/32

# Add inbound rule for MySQL (3306) from your IP only
echo "Adding inbound rule to Security Group..."
aws ec2 authorize-security-group-ingress \
    --group-id $SECURITY_GROUP_ID \
    --protocol tcp \
    --port 3306 \
    --cidr $MY_IP

# Create DB Subnet Group
#echo "Creating DB Subnet Group..."
#aws rds create-db-subnet-group \
#    --db-subnet-group-name $SUBNET_GROUP_NAME \
#    --db-subnet-group-description "Subnet group for Library DB" \
#    --subnet-ids "subnet-xxxxx" "subnet-yyyyy" # Replace with your subnet IDs

# Create RDS instance
echo "Creating RDS instance..."
aws rds create-db-instance \
    --db-instance-identifier $DB_INSTANCE_IDENTIFIER \
    --db-instance-class $DB_CLASS \
    --engine $ENGINE \
    --engine-version $ENGINE_VERSION \
    --allocated-storage $STORAGE_SIZE \
    --master-username $MASTER_USERNAME \
    --master-user-password $MASTER_PASSWORD \
    --vpc-security-group-ids $SECURITY_GROUP_ID \
    --db-subnet-group-name $SUBNET_GROUP_NAME \
    --publicly-accessible \
    --backup-retention-period 7 \
    --no-multi-az \
    --port 3306 \
    --no-auto-minor-version-upgrade

# Wait for DB instance to be available
echo "Waiting for RDS instance to be available..."
aws rds wait db-instance-available \
    --db-instance-identifier $DB_INSTANCE_IDENTIFIER

# Get the endpoint
ENDPOINT=$(aws rds describe-db-instances \
    --db-instance-identifier $DB_INSTANCE_IDENTIFIER \
    --query 'DBInstances[0].Endpoint.Address' \
    --output text)

echo "RDS instance created successfully!"
echo "Endpoint: $ENDPOINT"

# Create database and tables using mysql client
echo "Creating database and tables..."
mysql -h $ENDPOINT -u $MASTER_USERNAME -p$MASTER_PASSWORD << 'EOF'
CREATE DATABASE library;
USE library;

CREATE TABLE authors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    country VARCHAR(255)
);

CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author_id INT,
    genre VARCHAR(50),
    FOREIGN KEY (author_id) REFERENCES authors(id)
);

CREATE TABLE reading_status (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    status ENUM('reading', 'completed', 'planned') NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(id)
);

-- Insert sample data
INSERT INTO authors (name, country) VALUES
('George Orwell', 'United Kingdom'),
('J.K. Rowling', 'United Kingdom'),
('Haruki Murakami', 'Japan');

INSERT INTO books (title, author_id, genre) VALUES
('1984', 1, 'Dystopian'),
('Harry Potter and the Philosopher\'s Stone', 2, 'Fantasy'),
('Kafka on the Shore', 3, 'Magical realism');

INSERT INTO reading_status (book_id, status) VALUES
(1, 'reading');

-- Create application user
CREATE USER 'library_user'@'%' IDENTIFIED BY 'strong_password';
GRANT SELECT, INSERT, UPDATE ON library.* TO 'library_user'@'%';
FLUSH PRIVILEGES;
EOF

echo "Database setup completed!"