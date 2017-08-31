#!/bin/bash

################################################################################
# Author:    Aaron Polley                                                      #
# Date:      1/09/2017                                                        #
# Version:   0.05                                                              #
# Purpose:   Scripting for monitoring and resolving false mounts               #
#            Should be triggered by LaunchAgent using WatchPaths               #
################################################################################

#---Variables and such---#
script_version="0.05"
user_id=`id -u`
user_name=`id -un $user_id`
home_dir=`dscl . read /Users/"$user_name" NFSHomeDirectory | awk '{print $2}'`
log_file="/Library/Logs/fmWATCH.log"
os_vers=`sw_vers -productVersion | awk -F "." '{print $2}'`
DateTime=`date "+%a %b %d %H:%M:%S"`
currentUser=`/usr/bin/stat -f%Su /dev/console`



#---Redirect output to log---#
exec >> $log_file 2>&1

#---User Alert---#
#osascript -e "tell Application \"System Events\" to display alert\
# \"Incorrect server connection detected, removing\""

#---Script Start---#
echo "*************************************************************************"
echo "$DateTime - fmWATCH beginning v${script_version}"
echo "$DateTime     - User:              $user_name"
echo "$DateTime     - User ID:           $user_id"
echo "$DateTime     - Home Dir:          $home_dir"
echo "$DateTime     - OS Vers:           10.${os_vers}"
echo "$DateTime     - LoadUser:          $currentUser"

#--Slow down and let things legitimately mount---#

#echo "$DateTime - Pausing for 10 seconds..."

#sleep 10

echo "$DateTime - Building list of false mounts..."

falseMounts=`ls -l /Volumes/ | grep wheel | grep $currentUser | awk '{print $9,$10,$11,$12,$13}' | awk '{$1=$1};1'`

#---Adjust for loop delimiter---#
SAVEIFS=$IFS
IFS=$'\n'

for fmount in $falseMounts ; do

   fmount_point=$(echo "/Volumes/$fmount")
   echo "Removing '"$fmount_point"'"
   rmdir $fmount_point
   
done

#---Restore IFS---#
IFS=$SAVEIFS

echo "$DateTime - Complete..."

echo "*************************************************************************"

exit 0