#!/bin/bash

# Update the package list
sudo apt update

# Upgrade installed packages
sudo apt upgrade -y

# Install required dependencies
sudo apt install tomcat10 tomcat10-admin tomcat10-docs tomcat10-common git wget -y

# Verify Java installation (optional step to confirm it's using Java 22)
java -version

