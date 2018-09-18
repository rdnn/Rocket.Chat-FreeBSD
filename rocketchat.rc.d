#!/bin/sh

# PROVIDE: rocketchat
# REQUIRE: NETWORKING SERVERS DAEMON mongod
# BEFORE:  LOGIN
# KEYWORD: shutdown

. /etc/rc.subr

name="rocketchat"
forever="/usr/local/bin/node /usr/local/bin/forever"
workdir="/usr/local/rocketchat"
script="bundle/main.js"

rcvar=`set_rcvar`

start_cmd="start"
stop_cmd="stop"
restart_cmd="restart"

load_rc_config $name
eval "${rcvar}=\${${rcvar}:-'NO'}"

: ${rocketchat_user="rocketchat"}
: ${rocketchat_db="mongodb://localhost:27017/rocketchat"}
: ${rocketchat_oplog="mongodb://localhost:27017/local"}
: ${rocketchat_port="3000"}

start()
{
    echo "Starting rocketchat."
    su -m ${rocketchat_user} -c "env HOME=/var/run/rocketchat NODE_ENV=production MONGO_URL=${rocketchat_db} PORT=${rocketchat_port} ROOT_URL=http://localhost:3000 Accounts_AvatarStorePath=${workdir}/uploads ${forever} start --no-colors --minUptime 1000 --spinSleepTime 15000 -a -l /var/log/rocketchat/forever.log -o /dev/null -e /var/log/rocketchat/node.log ${workdir}/${script}"
}

stop()
{
    echo "Stopping rocketchat."
    su -m ${rocketchat_user} -c "env HOME=/var/run/rocketchat ${forever} stop --no-colors ${workdir}/${script}"
}

restart()
{
    echo "Restarting rocketchat."
    su -m ${rocketchat_user} -c "env HOME=/var/run/rocketchat ${forever} restart --no-colors ${workdir}/${script}"
}

run_rc_command "$1"
