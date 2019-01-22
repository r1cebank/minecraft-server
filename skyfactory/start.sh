#!/bin/sh

cd /minecraft

if [ ! -f /minecraft/LaunchServer.sh ]; then
    echo "Installing ftb server"
    wget https://media.forgecdn.net/files/2481/284/FTBPresentsSkyfactory3Server_3.0.15.zip && \
    unzip FTBPresentsSkyfactory3Server_3.0.15.zip && \
    rm FTBPresentsSkyfactory3Server_3.0.15.zip && \
    echo "#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula)." > eula.txt && \
    echo "$(date)" >> eula.txt && \
    echo "eula=TRUE" >> eula.txt
    chmod a+x /minecraft/ServerStart.sh

    set -e
    sed -i "/^minecraft/s/1000/${UID}/g" /etc/passwd
    sed -i "/^minecraft/s/1000/${GID}/g" /etc/group

    if [ "$SKIP_OWNERSHIP_FIX" != "TRUE" ]; then
        fix_ownership() {
            dir=$1
            if ! su-exec minecraft test -w $dir; then
                echo "Correcting writability of $dir ..."
                chown -R minecraft:minecraft $dir
                chmod -R u+w $dir
            fi
        }

        fix_ownership /minecraft
        fix_ownership /home/minecraft
    fi
    function setServerProp {
        local prop=$1
        local var=$2
        if [ -n "$var" ]; then
            echo "Setting $prop to $var"
            sed -i "/$prop\s*=/ c $prop=$var" /minecraft/server.properties
        fi
    }
    if [ ! -e server.properties ]; then
        echo "Creating server.properties"
        cp /tmp/server.properties .
        setServerProp "enable-rcon" "true"
        setServerProp "rcon.password" "password"
        setServerProp "rcon.port" "25575"
    fi
fi

echo "Switching to user 'minecraft'"
su-exec minecraft /minecraft/ServerStart.sh $@
