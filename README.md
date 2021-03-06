#Scripting for monitoring and resolving false mount points

A false mount “Watchdog”

Currently, it targets and addresses the empty mount points created in /Volumes by a bug in macOS 10.12 Sierra and above (resolved in a sub release of macOS 10.14 Mojave for most use cases). When a network drive is already mounted, further attempts to mount via Finder’s Go > Connect To Server or persistent scripting causes the creation of the empty directories

Install the latest release at https://github.com/aarondavidpolley/fmWATCH/releases

Note: the core script uses a non-destructive rmdir command that only removes empty directories in /Volumes, rather than an all destructive rm -rf style.

As of v1.0, pass a "debug" variable running from command line or LaunchDaemon for more verbose logging.  For example:

sudo sh /LibraryScripts/fmWATCH.sh debug

or

<key>ProgramArguments</key>
<array>
 <string>/Library/Scripts/fmWATCH.sh</string>
 <string>debug</string>
</array>

Logs are written to /Library/Logs/fmWATCH.log

This is available under the MIT License: https://github.com/aarondavidpolley/fmWATCH/blob/master/LICENSE

#Uninstall

As machines running Mojave, Catalina, etc may no longer need this tool and and want to remove it, an uninstall script has been created and made available here: https://github.com/aarondavidpolley/fmWATCH/blob/master/uninstall.sh
