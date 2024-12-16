#!/bin/bash

# Exit on error
set -e

# Check root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or use sudo"
  exit 1
fi

# Detect OS and set package manager
if [ -f /etc/os-release ]; then
  . /etc/os-release
  DISTRO=$ID
else
  echo "Unable to detect OS."
  exit 1
fi

# Determine the package manager based on the OS
if [[ "$DISTRO" == "ubuntu" || "$DISTRO" == "debian" ]]; then
  PACKAGE_MANAGER="apt"
  UPDATE_CMD="apt update"
  INSTALL_CMD="apt install -y"
  REMOVE_CMD="apt remove --purge -y"
  AUTOREMOVE_CMD="apt autoremove -y"
elif [[ "$DISTRO" == "centos" || "$DISTRO" == "rhel" || "$DISTRO" == "fedora" ]]; then
  PACKAGE_MANAGER="dnf"
  UPDATE_CMD="dnf update -y"
  INSTALL_CMD="dnf install -y"
  REMOVE_CMD="dnf remove -y"
  AUTOREMOVE_CMD="dnf autoremove -y"
else
  echo "Unsupported OS: $DISTRO"
  exit 1
fi

# Update and clean up the system
echo "Updating system..."
$UPDATE_CMD
$REMOVE_CMD mysql* && $AUTOREMOVE_CMD

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

# Add the MySQL APT repository (works for both Debian-based and Red Hat-based distros)
REPO_FILE="/etc/apt/sources.list.d/mysql.list"
if [ "$DISTRO" == "ubuntu" ] || [ "$DISTRO" == "debian" ]; then
  # For Debian/Ubuntu, we use APT repository
  if [ ! -f "$REPO_FILE" ]; then
    echo "Adding MySQL APT repository for version "
    wget https://dev.mysql.com/get/mysql-apt-config_0.${MYSQL_VERSION}-1_all.deb
    dpkg -i mysql-apt-config_0.${MYSQL_VERSION}-1_all.deb
    rm mysql-apt-config_0.${MYSQL_VERSION}-1_all.deb
  else
    echo "MySQL APT repository already exists."
  fi
elif [ "$DISTRO" == "centos" ] || [ "$DISTRO" == "rhel" ] || [ "$DISTRO" == "fedora" ]; then
  # For RedHat/CentOS/Fedora, we use YUM/DNF repository
  if [ ! -f "/etc/yum.repos.d/mysql-community.repo" ]; then
    echo "Adding MySQL YUM repository for version "
    wget https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
    rpm -ivh mysql80-community-release-el7-3.noarch.rpm
    rm mysql80-community-release-el7-3.noarch.rpm
  else
    echo "MySQL YUM repository already exists."
  fi
fi

# Update package index again
echo "Updating package index..."
$UPDATE_CMD

# Install MySQL server
echo "Installing MySQL server version "
$INSTALL_CMD mysql-server

# Start and enable MySQL service
echo "Starting MySQL service..."
systemctl start mysql
systemctl enable mysql

# Verify installation
echo "MySQL version installed successfully."
echo "Verifying MySQL installation..."
echo
echo "######################################"
mysql --version
echo "######################################"
echo
