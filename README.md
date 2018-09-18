# Rocket.Chat-FreeBSD
Easily run [Rocket.Chat](https://github.com/RocketChat/Rocket.Chat) on FreeBSD.

## Rocket.Chat Version
The installation script is currently configured to install Rocket.Chat 0.69.2. The installation script has only been tested on FreeBSD 11.2 with node 8.12.0 and npm 6.4.1.

## Installation
To begin the installation, run the following as a superuser:
```
fetch https://raw.githubusercontent.com/rdnn/Rocket.Chat-freebsd/master/rocketchat
chmod +x rocketchat
./rocketchat
```

Once complete, start the MongoDB and Rocket.Chat services:
```
service mongod start
service rocketchat start
```

The startup process can then be monitored:
```
tail -f /var/log/rocketchat/forever.log
```

If all goes well, you should see the following:
```
➔ +----------------------------------------------+
➔ |                SERVER RUNNING                |
➔ +----------------------------------------------+
➔ |                                              |
➔ |  Rocket.Chat Version: 0.69.2                 |
➔ |       NodeJS Version: 8.12.0 - x64           |
➔ |             Platform: freebsd                |
➔ |         Process Port: 3000                   |
➔ |             Site URL: http://localhost:3000  |
➔ |     ReplicaSet OpLog: Disabled               |
➔ |          Commit Hash: 7df9818105             |
➔ |        Commit Branch: HEAD                   |
➔ |                                              |
➔ +----------------------------------------------+
```

## How it Works
The installation script is a simple shell script that fetches the official [Rocket.Chat Docker deployment image](https://hub.docker.com/r/rocketchat/rocket.chat) and then extracts, modifies, builds, and installs Rocket.Chat. The installation script has rudimentary error checking and will not catch all errors. For that reason, among others, it is recommended that the installation script be used within a [jail](https://www.freebsd.org/doc/handbook/jails.html). Once executed, the installation script will...

1. Use `pkg` to install the packages required to build and run Rocket.Chat:
   * jq
   * mongodb36
   * node8
   * npm-node8
   * pkgconf
   * python
   * python2
   * python27
   * vips
2. Create a user and group named `rocketchat`
3. Create the required directories:
   * `/var/run/rocketchat`
   * `/var/log/rocketchat`
   * `/usr/local/rocketchat`
4. Download the Rocket.Chat Docker deployment image directly from [https://releases.rocket.chat](https://releases.rocket.chat)
5. Extract, make FreeBSD-specific modifications, build, and install Rocket.Chat in `/usr/local/rocketchat`
6. Configure [newsyslog](https://www.freebsd.org/cgi/man.cgi?newsyslog) for log management and rotation
7. Install [forever](https://www.npmjs.com/package/forever) globally to ensure Rocket.Chat runs continuously8. Install a [rc.d script](https://raw.githubusercontent.com/rdnn/Rocket.Chat-freebsd/master/rocketchat.rc.d) in `/usr/local/etc/rc.d` to allow the [service](https://www.freebsd.org/cgi/man.cgi?service) command to manage Rocket.Chat
9. Enable the MongoDB and Rocket.Chat services in `/etc/rc.conf`
