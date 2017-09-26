#!/bin/sh

preserve_agent_files=0

for arg in $@; do
    if [ $arg = "--preserve-agent-files" ]; then
        preserve_agent_files=1
    fi
done

launchctl unload /Library/LaunchDaemons/com.labtechsoftware.LTSvc.plist &> /dev/null
LOGGEDUSERS=`who | grep console | awk '{ print $1 }'`
for CURRUSER in $LOGGEDUSERS
do
    su -l $CURRUSER -c 'launchctl unload /Library/LaunchAgents/com.labtechsoftware.LTTray.plist'
done
launchctl unload /Library/LaunchDaemons/com.labtechsoftware.LTUpdate.plist &> /dev/null

if [ $preserve_agent_files -eq 0 ]; then
    rm -rf /usr/local/ltechagent

    LOGGEDUSERS=`who | grep console | awk '{ print $1 }'`
    for CURRUSER in $LOGGEDUSERS
    do
        rm -Rf /Users/$CURRUSER/.labtech
    done
fi

rm -f /Library/LaunchDaemons/com.labtechsoftware.LTSvc.plist
rm -f /Library/LaunchAgents/com.labtechsoftware.LTTray.plist
rm -f /Library/LaunchDaemons/com.labtechsoftware.LTUpdate.plist
