#!/bin/bash

################################################################################
# Author:    Aaron Polley                                                      #
# Date:      31/08/2017                                                        #
# Version:   0.01                                                              #
# Purpose:   Scripting for monitoring and resolving false mounts               #
#            Should be triggered by LaunchAgent using WatchPaths               #
################################################################################

#---Variables and such---#
script_version="0.01"
user_id=`id -u`
user_name=`id -un $user_id`
home_dir=`dscl . read /Users/"$user_name" NFSHomeDirectory | awk '{print $2}'`
log_file="$home_dir/Library/Logs/fmWATCH.log"
os_vers=`sw_vers -productVersion | awk -F "." '{print $2}'`
DateTime=`date "+%a %b %d %H:%M:%S"`

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

#--Slow down and let things legitimately mount---#

echo "$DateTime - Pausing for 10 seconds..."

sleep 10

echo "$DateTime - Building list of false mounts..."

falseMounts=`ls -l /Volumes/ | grep wheel | grep aaron | awk '{print $9,$10,$11,$12,$13}' | awk '{$1=$1};1'`

for fmount in $falseMounts ; do

   fmount_point=$(echo "/Volumes/$fmount")
   echo $fmount_point
   
done

echo "$DateTime - Complete..."

echo "*************************************************************************"

exit 0