#!/bin/bash
#
# Author: Supriyo Roy
# Date: 2023-07-01
# Email: roysupriyoroy73@gmail.com
# Description: This script will help you to create a wordpress website , wich will be created using the LEMP stack.


#This function will check if docker & docker-compose is installed or not
function checker() {
   if [ -x "$(command -v "$1" 2>/dev/null)" ]
   then 
      echo "$1 is installed on the system"
   else
      echo "$1 is not installed on the system. Installing $1...."
      installer "$1"
   fi
}

# This function will install the required package
function installer() {
   package="$1"
   if [ -x "$(command -v apt-get)" ]
   then
      echo "Installing $package using apt-get..."
      sudo apt-get update -y
      sudo apt-get install -y "$package"
   elif [ -x "$(command -v yum)" ]
   then
      echo "Installing $package using yum..."
      sudo yum update -y
      sudo yum install -y "$package"
   else
      echo "Cannot install $package. No package manager found."
   fi
}

# This loop will check and install necessary packages

packages=("docker-compose" "docker")

for package in "${packages[@]}"; do
   checker "$package"
done

#Getting the site name from user

read -p "Enter the site name: " site_name


# function to create a WordPress site

function create_wp_site() {
   echo "Creating WordPress site: $1"

    
   # Creating a nginx configuration

   echo "server {
      listen 80;
      server_name $1;

      location / {
         proxy_pass http://wordpress:80;
         proxy_set_header Host \$host;
         proxy_set_header X-Real-IP \$remote_addr;
      }
   }" > ./default.conf

# Create docker-compose.yml file

   echo "version: '3.1'
services:  
  mysql_db:
    container_name: mysql_container
    image: mysql:latest
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: wp_db
      MYSQL_USER: wp_user
      MYSQL_PASSWORD: wp_user_pwd
    volumes:
     - mysql_vol:/var/lib/mysql
  wordpress:
    container_name: wordpress_container
    image: wordpress:latest
    restart: always
    ports:
      - '80:80'
    environment:
      WORDPRESS_DB_HOST: mysql_db:3306
      WORDPRESS_DB_USER: wp_user
      WORDPRESS_DB_PASSWORD: wp_user_pwd
      WORDPRESS_DB_NAME: wp_db
    volumes:
      - ./:/var/www/html
  nginx:
    container_name: nginx_container
    image: nginx:latest
    ports:
      - '8080:80'
    volumes:
       - ./:/etc/nginx/conf.d
    depends_on:
       - wordpress
volumes:
  mysql_vol: {}" > ./docker-compose.yml

docker-compose up -d #this is bring up the containers
     
}

#function to remove the container and local files created

function delete_everything() {
   docker-compose down --volume
   find . -type f ! -name "script.sh" -exec rm -f {} +  #this command will remove all containers and the local files except the script 
   echo "Containers and local files are removed."
}

#this function will add an entry of the site name to /etc/hosts , like 127.0.0.1 <site_name>

function add_hosts_entry() {
   echo "Adding /etc/hosts entry..."
   echo "127.0.0.1 $site_name" | sudo tee -a /etc/hosts >/dev/null
   echo "/etc/hosts entry added."
}

#this function will ask the user to open the site in there desired broeser

function prompt_open_browser() {
   read -p "Do you want to open the site in a browser? (Y/N): " open_browser
   if [[ "$open_browser" =~ ^[Yy]$ ]]; then
      echo "Please copy and open the following URL in your desired browser:"
      echo "http://$site_name:8080"
   fi
}

while true; do
   echo "1. Create and Enable WordPress site"
   echo "2. Open example.com in a browser"
   echo "3. Delete site and local files"
   echo "4. Quit"

read -p "Select an option: " option
case $option in
      1)
         create_wp_site "$site_name"
         add_hosts_entry "$site_name"
         ;;
      2)
         prompt_open_browser "$site_name"
         ;;
      3)
         delete_everything
         ;;
      4)
         echo "Exiting..."
         break
         ;;
      *)
         echo "Invalid option. Please try again."
         ;;
   esac
done
