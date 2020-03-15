#!/bin/bash
# slack-plexautoupdate

# What he will do
# 1 - catch the latest version and compare to the one you already have (if you do)
# 2 - call plexmediaserver.slackBuild and build the package
# 3 - call autoUpgrade.py to update your plexmediaserver
# 4 - restart the service with /etc/rc.d/rc.plexmediaserver restart

# Place your Plex Token here if you have Plex Pass, otherwise leave it blank.
plexToken=""


downURL="https://plex.tv/downloads/latest/1?channel=8&build=linux-ubuntu-x86_64&distro=ubuntu&X-Plex-Token=$plexToken"

scriptDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
shortDate=$(date +'%d-%m-%Y %H:%M:%S')
echo "Exec script"
# get current release PMS version
function getCurrent {
# pour la release, ajouter un grep sed 's/-.*//' si l'on ne veut plus le commit derriere
releaseVersion=$(curl -LsI $1 | grep "Location:" | awk -F'/' '{print $5}' )
release=$(curl -LsI $1 | grep "Location:" | awk -F'/' '{print $5}' | sed 's/-.*//')
}

# get installed PMS version
function getInstalled {
# for awk, add print $2"-"$3 if you want the commit behind
installedVersion=$(ls /var/log/packages | grep plexmediaserver | awk -F '-' '{print $2"-"$3}')
installed=$(ls /var/log/packages | grep plexmediaserver | awk -F '-' '{print $2}')
}

cd $scriptDir
# update PMS
function updatePlex {
# Add a break if releaseVersion is empty
if [ -z "$releaseVersion" ]
then
  break
fi
echo downloading update...
wget $downURL -O plexmediaserver_"$releaseVersion"_amd64.deb
echo installing update...
./plexmediaserver.SlackBuild $releaseVersion || echo "slackBuild fail, check the script" && exit 1
echo cleaning up old files...
rm -f $path/plexmediaserver_$installedVersion*
echo done!
}


# Pushbullet notification
# If you want to enable it, uncomment it, change the access token.

#function sendNotification {
#printf -v JSON_STRING '{"body":"Plex Media server updated from '$installed' to '$release'","title":"Slack-o-Plex Upgrade","type":"note"}'
#curl -s -i --header 'Access-Token: CHANGE_ME_PLEASE' \
#	--header 'Content-Type: application/json' \
#	--data-binary "$JSON_STRING" \
#	--request POST \
#	https://api.pushbullet.com/v2/pushes > /dev/null
#}

getCurrent $downURL
getInstalled
echo Installed Version: $installedVersion $installed
echo Release Version: $releaseVersion $release

if [ "$installed" != "$release" ]; then
	echo "update available!"
	#sendNotification
	echo "$shortDate - Updated PlexMediaServer from Version:$installedVersion to Version:$releaseVersion " >> "$scriptDir/plexUpdate.log"
	updatePlex $1
	else
	echo "Server is up to date. Exiting..."
fi
