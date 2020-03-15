# slack-plexautoupdate

**This script is use with plexmediaserver package from SlackBuilds** (https://slackbuilds.org/repository/14.2/multimedia/plexmediaserver/?search=plexmediaserver)

It intents to automate plexmediaserver update without any user action. It's totally homemade and a lot of improvements can be provided in code quality.

Actually I did those scripts to work some python and to not lose 10 minutes each time to update my server. And I'm fine with it for now.


# Main features
- Request plexmediaserver repository (with or without PlexPass) to get the latest version
- Download the .deb and pass the package through the slackbuild
- Get the final build and use the command "upgradepkg" built-in with Slackware. If you use Pushbullet, you can send a notification through their API.
- Keep five versions and wipe the oldests you could've build/package.
- Auto restart your PlexMediaServer at each update.




# Howto
- Get the official [slackbuild package](https://slackbuilds.org/slackbuilds/14.2/multimedia/plexmediaserver.tar.gz)
- Clone the repository, and put the content in the same folder 
 >  It will overwrite plexmediaserver.slackBuild, no worries about it unless you want to see diff between them. It will give flexibility to versions you input in the build, call autoUpgrade.py at the end, and restart the service.  
- Cron "autoCatch.sh" in your crontab depends the schedule you want.
- Enjoy ! 


