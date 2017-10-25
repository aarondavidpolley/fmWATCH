# fmWATCH

In development scripting for monitoring and resolving false mounts

Currently, targets and addresses the empty mount points created in /Volumes by a bug in macOS 10.12 Sierra and above. When a network drive is already mounted, further attempts to mount via Go > Connect To Server or persistent scripting cause the creation of the empty ditectories

To use/test, install the latest release at https://github.com/aarondavidpolley/fmWATCH/releases

Use at your own risk.

Note: the core script uses a non-destructive rmdir command that only removes empty directories in /Volumes, rather than an all destructive rm -rf style.

This is available under the MIT License:
https://github.com/aarondavidpolley/fmWATCH/blob/master/LICENSE