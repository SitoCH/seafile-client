# Source code
The original source code is available at [gitlab.com/flwgns-docker/seafile-client](https://gitlab.com/flwgns-docker/seafile-client/).
This Docker image is licensed under GPLv3.  

# Usage
The *Seafile* daemon is running as the user `seafuser` from it's directories `~/.seafile/` and `~/.ccnet`.

The library is synced at `/volume/`.

The *Seafile* daemon is managed with *supervisord* since it can't run as a foreground process.
The *supervisord* is running from `~/.supervisord/`, the `supervisord.conf`, `supervisord.log` and `supervisord.pid` can be found there.  
*supervisord* also manage a shell script, `~/infinite-seaf-cli-start.sh` which stop then start the Seafile daemon every 20 minutes: the synchronisation might not work properly if the Seafile daemon is not restarted from times to times, for an unresolved reason.
## Examples
You would have to share the path `/volume/` to other containers, with the following approaches:
### Docker CLI
```
docker run \ 
    -e SEAF_SERVER_URL= \           # The URL to your Seafile server.
    -e SEAF_USERNAME= \             # Your Seafile username.
    -e SEAF_PASSWORD= \             # Your Seafile password
    -e SEAF_LIBRARY_PASSWORD= \     # Your Seafile password
    -e SEAF_LIBRARY_UUID= \         # The Seafile library UUID you want to sync with.
    -e UID= \                       # Default is 1000.
    -e GID= \                       # Default is 1000.
    -v your/shared/volume:/volume \
    flowgunso/seafile-client:latest
```

# Environment variables
The following environment variable are available.

## Seafile
This Docker **must be configured with the following**, **otherwise** it **will not run**:
### SEAF_SERVER_URL
The URL to your Seafile server.
### SEAF_USERNAME
Your Seafile account's username.
### SEAF_PASSWORD
Your Seafile account's password.
### SEAF_LIBRARY_UUID
The Seafile library UUID you want to use.
### SEAF_LIBRARY_PASSWORD
The Seafile library password you want to use.

## User permissions
This Docker is **not running as `root` but as `seafuser`**. You can override the user/group ID used with:
### UID
The user ID defaults to `1000`. You may want to override this variable to prevent permission issues.
### GID
The group ID defaults to `1000`. Similarly, you may want to override this variable to prevent permission issues.
