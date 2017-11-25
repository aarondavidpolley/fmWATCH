#!/bin/bash

################################################################################
# Author:    Aaron Polley                                                      #
# Date:      25/11/2017                                                        #
# Version:   1.0                                                               #
# Purpose:   Scripting for monitoring and resolving false mounts               #
#            Should be triggered by LaunchDaemon using WatchPaths              #
################################################################################

#---Variables and such---#
script_version="1.0"
user_id=`id -u`
user_name=`id -un $user_id`
home_dir=`dscl . read /Users/"$user_name" NFSHomeDirectory | awk '{print $2}'`
log_file="/Library/Logs/fmWATCH.log"
os_vers=`sw_vers -productVersion | awk -F "." '{print $2}'`
DateTime=`date "+%a %b %d %H:%M:%S"`
currentUser=`/usr/bin/stat -f%Su /dev/console`

#---Redirect output to log---#
exec >> $log_file 2>&1

#---Script Start---#
if [[ $1 = "debug" ]]; then
echo "*************************************************************************"
echo "$DateTime - fmWATCH beginning v${script_version}"
echo "$DateTime     - User:              $user_name"
echo "$DateTime     - User ID:           $user_id"
echo "$DateTime     - Home Dir:          $home_dir"
echo "$DateTime     - OS Vers:           10.${os_vers}"
echo "$DateTime     - LoadUser:          $currentUser"
fi

#--Slow down and let things legitimately mount---#
if [[ $1 = "debug" ]]; then
echo "$DateTime - Pausing for 5 seconds..."
fi

sleep 5

if [[ $1 = "debug" ]]; then
echo "$DateTime - Building list of false mounts..."
fi

falseMounts=`ls -l /Volumes/ | grep wheel | grep $currentUser | awk '{print $9,$10,$11,$12,$13}' | awk '{$1=$1};1'`


if [[ $falseMounts > 0 ]]; then

  if [[ $1 = "debug" ]]; then
  echo "$DateTime - False Mounts found, attempting to remove:"
  fi

  #---Adjust for loop delimiter---#
  SAVEIFS=$IFS
  IFS=$'\n'

  for fmount in $falseMounts ; do

     fmount_point=$(echo "/Volumes/$fmount")
     echo "$DateTime - Removing '"$fmount_point"'"
     rmdir $fmount_point

  done

  #---Restore IFS---#
  IFS=$SAVEIFS

else

  if [[ $1 = "debug" ]]; then
  echo "$DateTime - No False Mounts found"
  fi

fi

if [[ $1 = "debug" ]]; then
echo "$DateTime - Complete..."

echo "*************************************************************************"
fi

exit 0
