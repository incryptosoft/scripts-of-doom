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

# Creates a backup
cp /etc/netplan/01-netcfg.yaml /etc/netplan/01-netcfg.yaml.bk_`date +%Y%m%d%H%M`
# Changes dhcp from 'yes' to 'no'
sed -i "s/dhcp4: yes/dhcp4: no/g" /etc/netplan/01-netcfg.yaml
# Retrieves the NIC information
nic=`ifconfig | awk 'NR==1{print $1}'`
# Ask for input on network configuration
read -p "Enter the static IP of the server in CIDR notation: " staticip 
read -p "Enter the IP of your gateway: " gatewayip
read -p "Enter the IP of preferred nameservers (seperated by a coma if more than one): " nameserversip
read -p "Enter the Host Name of this server: " newhostname
echo
hostnamectl set-hostname $newhostname
cat > /etc/netplan/01-netcfg.yaml <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    $nic
      addresses:
        - $staticip
      gateway4: $gatewayip
      nameservers:
          addresses: [$nameserversip]
EOF
sudo netplan apply
echo "==========================="
echo
read -p "The server must reboot now, press enter to reboot..." pressenter
echo
reboot
