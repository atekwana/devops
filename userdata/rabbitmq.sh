#!/bin/bash

echo "Importing RabbitMQ signing keys..."
## primary RabbitMQ signing key
rpm --import 'https://github.com/rabbitmq/signing-keys/releases/download/3.0/rabbitmq-release-signing-key.asc'
## modern Erlang repository
rpm --import 'https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-erlang.E495BB49CC4BBE5B.key'
## RabbitMQ server repository
rpm --import 'https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-server.9F4587F226208342.key'

echo "Downloading repository configuration..."
curl -o /etc/yum.repos.d/rabbitmq.repo https://raw.githubusercontent.com/hkhcoder/vprofile-project/refs/heads/awsliftandshift/al2023rmq.repo

echo "Updating package metadata..."
dnf update -y

echo "Installing dependencies..."
## install these dependencies from standard OS repositories
dnf install socat logrotate -y

echo "Installing RabbitMQ and Erlang..."
## install RabbitMQ and zero dependency Erlang
dnf install -y erlang rabbitmq-server

echo "Configuring RabbitMQ service..."
systemctl enable rabbitmq-server
systemctl start rabbitmq-server

echo "Setting up RabbitMQ configuration..."
sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'

echo "Creating and configuring admin user..."
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator
rabbitmqctl set_permissions -p / test ".*" ".*" ".*"

echo "Restarting RabbitMQ service..."
sudo systemctl restart rabbitmq-server

echo "RabbitMQ installation and configuration complete."