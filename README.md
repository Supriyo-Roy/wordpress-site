## Hi Everyone,

### This script will help you create a WordPress website using the LEMP stack.
### The script will run and install all the necessary packages (docker & docker-compose) to set up the website. It is compatible with both *Red Hat-based* and *Debian-based distributions*.**

### The script will create 3 containers ,MySQL, Nginx, Wordpress (this image contains PHP)

**Note:** You need to run the script as  root.
### **Step 1:** Clone the repository: 

```sh
git clone https://github.com/Supriyo-Roy/wordpress-site.git
```
### **Step 2:** Run the script :-
```sh 
sudo bash script.sh 
```
### This will prompt you to choose your options from below :-

### Firstly enter your desired site name like *example.com*

```plaintext
Enter the site name: example.com
1. Create and Enable WordPress site
2. Open example.com in a browser
3. Delete site and local files
4. Quit
Select an option:
```

### **Step 3:** Choose your desired option.

### **Step 4:** To view your site, select option *2*.

### **Step 5:** To delete all containers and local files, select option *3*.


