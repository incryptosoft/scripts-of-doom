#!/bin/bash

# Remove cloud-init
echo 'datasource_list: [ None ]' | sudo -s tee /etc/cloud/cloud.cfg.d/90_dpkg.cfg
apt-get purge cloud-init -y
rm -rf /etc/cloud/; rm -rf /var/lib/cloud/

# Set sudo without password
# NOTICE: REPLACE `administrator` with the username you want to use
echo "administrator  ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/administrator

### Update All Packages ###
apt update
apt upgrade -y

### Update the login banner ###
apt install neofetch -y
chmod -x /etc/update-motd.d/*
cat > /etc/update-motd.d/banner.txt <<EOL
 /$$            /$$$$$$                                  /$$                       
|__/           /$$__  $$                                | $$                       
 /$$ /$$$$$$$ | $$  \__/  /$$$$$$  /$$   /$$  /$$$$$$  /$$$$$$    /$$$$$$          
| $$| $$__  $$| $$       /$$__  $$| $$  | $$ /$$__  $$|_  $$_/   /$$__  $$         
| $$| $$  \ $$| $$      | $$  \__/| $$  | $$| $$  \ $$  | $$    | $$  \ $$         
| $$| $$  | $$| $$    $$| $$      | $$  | $$| $$  | $$  | $$ /$$| $$  | $$         
| $$| $$  | $$|  $$$$$$/| $$      |  $$$$$$$| $$$$$$$/  |  $$$$/|  $$$$$$/         
|__/|__/  |__/ \______/ |__/       \____  $$| $$____/    \___/   \______/          
                                   /$$  | $$| $$                                   
                                  |  $$$$$$/| $$                                   
                                   \______/ |__/                                   
  /$$$$$$             /$$$$$$   /$$                                                
 /$$__  $$           /$$__  $$ | $$                                                
| $$  \__/  /$$$$$$ | $$  \__//$$$$$$   /$$  /$$  /$$  /$$$$$$   /$$$$$$   /$$$$$$ 
|  $$$$$$  /$$__  $$| $$$$   |_  $$_/  | $$ | $$ | $$ |____  $$ /$$__  $$ /$$__  $$
 \____  $$| $$  \ $$| $$_/     | $$    | $$ | $$ | $$  /$$$$$$$| $$  \__/| $$$$$$$$
 /$$  \ $$| $$  | $$| $$       | $$ /$$| $$ | $$ | $$ /$$__  $$| $$      | $$_____/
|  $$$$$$/|  $$$$$$/| $$       |  $$$$/|  $$$$$/$$$$/|  $$$$$$$| $$      |  $$$$$$$
 \______/  \______/ |__/        \___/   \_____/\___/  \_______/|__/       \_______/
                                                                                   
------------------------------------------------------------------------------------

EOL

cat > /etc/update-motd.d/99-custom <<EOL
#!/bin/bash
cat /etc/update-motd.d/banner.txt
neofetch

EOL

chmod +x /etc/update-motd.d/99-custom

/etc/update-motd.d/99-custom

