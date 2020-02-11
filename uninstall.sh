#!/bin/bash

################################################################################
# Author:    Aaron Polley                                                      #
# Date:      12/02/2020                                                        #
# Version:   1.0                                                               #
# Purpose:   Uninstall script for fmWATCH                                      #
################################################################################

#---Variables and such---#
script_version="1.0"
user_id=$(id -u)
user_name=$(id -un "${user_id}")
home_dir=$(dscl . read /Users/"$user_name" NFSHomeDirectory | awk '{print $2}')
log_file="/var/log/fmWATCH_uninstall.log"
os_vers=$(sw_vers -productVersion | awk -F "." '{print $2}')
currentUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }' )
DateTime=$(date "+%a %b %d %H:%M:%S")
launchItems=("/Library/LaunchDaemons/com.max.fmwatch.plist" "/Library/LaunchDaemons/com.github.aarondavidpolley.fmWATCH.plist")
removalItems=("/Library/Scripts/fmWATCH.sh" "/Library/Logs/fmWATCH.log" "/var/log/fmWATCH_install.log")
WHOAREYOU=$(whoami)

#---User Check--#
if [ "$WHOAREYOU" != "root" ]
then
	echo "$(date '+%Y-%m-%d_%H-%M-%S') ERROR: You need to run with sudo/root privileges, exiting..."
	exit 1
fi

#---Redirect output to log---#
exec >> $log_file 2>&1


#---Script Start---#
echo "*************************************************************************"
echo "$DateTime - fmWATCH uninstall v${script_version}"
echo "$DateTime     - User:              $user_name"
echo "$DateTime     - User ID:           $user_id"
echo "$DateTime     - Home Dir:          $home_dir"
echo "$DateTime     - OS Vers:           10.${os_vers}"
echo "$DateTime     - LoadUser:          $currentUser"

# Run uninstall actions for root.

echo "$DateTime - Unloading and removing components"

for item in "${launchItems[@]}";
do
	if [ -e "${item}" ]
	then
		echo "Found and removing LaunchD item ${item}"
		launchctl unload -w "${item}"
		rm -rfv "${item}"
	else
		echo "Did not find ${item}"
	fi
done

for item in "${removalItems[@]}";
do
	if [ -e "${item}" ]
	then
		echo "Found and removing item ${item}"
		rm -rfv "${item}"
	else
		echo "Did not find ${item}"
	fi
done

echo "$DateTime - Complete..."

echo "*************************************************************************"

exit 0
