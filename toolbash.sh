#!/bin/bash

# Exit on error
set -e

# Check root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or use sudo"
  exit 1
fi

# Update and clean up the system
echo "Updating system..."
apt update && apt upgrade -y
apt remove --purge -y mysql* && apt autoremove -y

# Function to display version choices
function choose_version() {
  echo "Choose the MySQL version to install:"
  echo "1) MySQL 8.0"
  echo "2) MySQL 8.4 (latest)"
  echo "3) Exit"
  read -p "Enter your choice [1-3]: " choice

  case $choice in
    1|2) MYSQL_VERSION="8.33" ;;
    3) echo "Exiting."; exit 0 ;;
    *) echo "Invalid choice, please try again."; choose_version ;;
  esac
}

# Call the function
choose_version

# Confirm the version
read -p "Do you want to proceed with installation? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
  echo "Installation canceled."
  exit 0
fi

# Add the MySQL APT repository
REPO_FILE="/etc/apt/sources.list.d/mysql.list"
if [ ! -f "$REPO_FILE" ]; then
  echo "Adding MySQL APT repository for version ..."
  wget https://dev.mysql.com/get/mysql-apt-config_0.${MYSQL_VERSION}-1_all.deb
  dpkg -i mysql-apt-config_0.${MYSQL_VERSION}-1_all.deb
  rm mysql-apt-config_0.${MYSQL_VERSION}-1_all.deb
else
  echo "MySQL APT repository already exists."
fi

# Update package index
echo "Updating package index..."
apt update

# Install MySQL server
echo "Installing MySQL server version ..."
apt install -y mysql-server


# Start and enable MySQL service
echo "Starting MySQL service..."
systemctl start mysql
systemctl enable mysql

# Verify installation
echo "MySQL version installed successfully."
echo "Verifying MySQL installation..."
echo "######################################"
echo "######################################"
echo
mysql --version
echo
echo "######################################"
echo "######################################"
