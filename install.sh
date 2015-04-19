#!/bin/bash
#---------------------------------------------------------------------
# install.sh
#
# ISPConfig 3 system installer
#
# Script: install.sh
# Version: 1.0.5
# Author: Matteo Temporini <temporini.matteo@gmail.com>
# Description: This script will install all the packages needed to install
# ISPConfig 3 on your server.
#
#
#---------------------------------------------------------------------



#---------------------------------------------------------------------
# Global variables
#---------------------------------------------------------------------
CFG_HOSTNAME_FQDN=`hostname -f`;
WT_BACKTITLE="ISPConfig 3 System Installer from Temporini Matteo"

# Bash Colour
red='\033[0;31m'
green='\033[0;32m'
NC='\033[0m' # No Color


#Saving current directory
PWD=$(pwd);

clear

#---------------------------------------------------------------------
# Load needed Modules
#---------------------------------------------------------------------


source $PWD/debian/modules/installbasics.sh
source $PWD/debian/modules/preinstallcheck.sh
source $PWD/debian/modules/askquestions.sh
source $PWD/debian/modules/installpostfix.sh
source $PWD/debian/modules/installmysql.sh
source $PWD/debian/modules/installmta.sh
source $PWD/debian/modules/installantivirus.sh
source $PWD/debian/modules/installwebserver.sh
source $PWD/debian/modules/installftp.sh
source $PWD/debian/modules/installquota.sh
source $PWD/debian/modules/installbind.sh
source $PWD/debian/modules/installwebstats.sh
source $PWD/debian/modules/installjailkit.sh
source $PWD/debian/modules/installfail2ban.sh
source $PWD/debian/modules/installwebmail.sh
source $PWD/debian/modules/installispconfig.sh
source $PWD/debian/modules/installfix.sh

#---------------------------------------------------------------------
# Main program [ main() ]
#    Run the installer
#---------------------------------------------------------------------

echo "========================================="
echo "ISPConfig 3 System installer"
echo "========================================="
echo
echo "This script will do a nearly unattended intallation of"
echo "all software needed to run ISPConfig 3."
echo "When this script starts running, it'll keep going all the way"
echo "So before you continue, please make sure the following checklist is ok:"
echo
echo "- This is a clean / standard debian installation";
echo "- Internet connection is working properly";
echo
echo "If you're all set, press ENTER to continue or CTRL-C to cancel.."
read DUMMY

if [ -f /etc/debian_version ]; then
  PreInstallCheck 2> /var/log/ispconfig_setup.log
  AskQuestions 
  InstallBasics 2>> /var/log/ispconfig_setup.log
  InstallPostfix 2>> /var/log/ispconfig_setup.log
  InstallMysql 2>> /var/log/ispconfig_setup.log
  InstallMTA 2>> /var/log/ispconfig_setup.log
  InstallAntiVirus 2>> /var/log/ispconfig_setup.log
  InstallWebServer 2>> /var/log/ispconfig_setup.log
  InstallFTP 2>> /var/log/ispconfig_setup.log
  if [ $CFG_QUOTA == "y" ]; then
	InstallQuota 2>> /var/log/ispconfig_setup.log
  fi
  InstallBind 2>> /var/log/ispconfig_setup.log
  InstallWebStats 2>> /var/log/ispconfig_setup.log
  if [ $CFG_JKIT == "y" ]; then
	InstallJailkit 2>> /var/log/ispconfig_setup.log
  fi
  InstallFail2ban 2>> /var/log/ispconfig_setup.log
  InstallWebmail 2>> /var/log/ispconfig_setup.log
  InstallISPConfig 2>> /var/log/ispconfig_setup.log
  InstallFix
  echo -e "${green}Well done ISPConfig installed and configured correctly :D${NC}"
  echo "No you can connect to your ISPConfig installation ad https://$CFG_HOSTNAME_FQDN:8080 or https://IP_ADDRESS:8080"
  echo "You can visit my GitHub profile at https://github.com/servisys/ispconfig_setup/"
  if [ $CFG_WEBSERVER == "nginx" ]; then
  	echo "Phpmyadmin is accessibile at  http://$CFG_HOSTNAME_FQDN:8081/phpmyadmin or http://IP_ADDRESS:8081/phpmyadmin";
	echo "Webmail is accessibile at  http://$CFG_HOSTNAME_FQDN:8081/webmail or http://IP_ADDRESS:8081/webmail";
  fi
else
  echo "${red}Unsupported linux distribution.${NC}"
fi

exit 0

