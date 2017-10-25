#!/bin/bash

################################################################################
# Author:    Aaron Polley                                                      #
# Date:      25/10/2017                                                         #
# Version:   0.1                                                              #
# Purpose:   Post install script for fmWATCH                                   #
################################################################################

#---Variables and such---#
script_version="0.1"
user_id=`id -u`
user_name=`id -un $user_id`
home_dir=`dscl . read /Users/"$user_name" NFSHomeDirectory | awk '{print $2}'`
log_file="/var/log/fmWATCH_install.log"
os_vers=`sw_vers -productVersion | awk -F "." '{print $2}'`
currentUser=`/usr/bin/stat -f%Su /dev/console`
DateTime=`date "+%a %b %d %H:%M:%S"`
OldVersion="/Library/LaunchDaemons/com.max.fmwatch.plist"

#---Redirect output to log---#
exec >> $log_file 2>&1


#---Script Start---#
echo "*************************************************************************"
echo "$DateTime - fmWATCH postinstall v${script_version}"
echo "$DateTime     - User:              $user_name"
echo "$DateTime     - User ID:           $user_id"
echo "$DateTime     - Home Dir:          $home_dir"
echo "$DateTime     - OS Vers:           10.${os_vers}"
echo "$DateTime     - LoadUser:          $currentUser"

# Run postinstall actions for root.

echo "$DateTime - Loading scripts into launchd"

# Add commands to execute in system context here.

#Check if v0.06 LaunchDaemon exists#

if [ -e "$OldVersion" ]; then 

#Unload and remove old Daemon#

launchctl unload -w /Library/LaunchDaemons/com.max.fmwatch.plist
rm /Library/LaunchDaemons/com.max.fmwatch.plist

else

#Unload LaunchDaemon#

launchctl unload /Library/LaunchDaemons/com.github.aarondavidpolley.fmWATCH.plist

fi

#Load LaunchDaemon#

launchctl load -w /Library/LaunchDaemons/com.github.aarondavidpolley.fmWATCH.plist

echo "$DateTime - Complete..."

echo "*************************************************************************"

exit 0