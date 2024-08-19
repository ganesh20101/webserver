import boto3

# Specify the region here
session = boto3.Session(region_name='ap-southeast-2')  # Replace 'us-east-1' with your desired region
ec2 = session.resource('ec2')

def launch_instance():
    instances = ec2.create_instances(
        ImageId='ami-0a6e89a01d7a32804',
        InstanceType='t2.micro',
        MinCount=1,
        MaxCount=1,
        KeyName='ganesh',
        SecurityGroupIds=['sg-01f0e808ccab56ea3'],
        SubnetId='subnet-0ab33bbef194babcb',
        UserData='''#!/bin/bash
                    # Install necessary packages
                    sudo yum update -y
                    sudo yum install java-11 -y 

                     # Set Tomcat version and download URL
                    TOMCAT_VERSION=10.1.28
                    TOMCAT_URL=https://dlcdn.apache.org/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.zip

                    # Define the installation directory
                    INSTALL_DIR=/opt/tomcat

                    # Create the installation directory
                    sudo mkdir -p ${INSTALL_DIR}

                    # Download Tomcat
                    wget ${TOMCAT_URL} -O /tmp/apache-tomcat-${TOMCAT_VERSION}.zip

                    # Extract Tomcat to the /opt/tomcat directory
                    sudo unzip /tmp/apache-tomcat-${TOMCAT_VERSION}.zip -d ${INSTALL_DIR}
                    sudo mv ${INSTALL_DIR}/apache-tomcat-${TOMCAT_VERSION}/* ${INSTALL_DIR}/

                    sudo chown -R ec2-user:ec2-user ${INSTALL_DIR}

                     # Set appropriate permissions
                    

                    # Ensure the ec2-user has write permissions for the logs directory
                    

                    # Make the Tomcat scripts executable
                    sudo chmod +x ${INSTALL_DIR}/bin/*.sh
                    sudo chmod 777 /opt/tomcat/logs/catalina.out

                    # Start the Tomcat server
                    ${INSTALL_DIR}/bin/startup.sh
                    echo "Tomcat has been started successfully."
                 '''
    )
    instance = instances[0]
    instance.wait_until_running()
    instance.reload()
    print("Instance ID:", instance.id)
    print("Public IP:", instance.public_ip_address)

launch_instance()
