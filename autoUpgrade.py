#!/usr/env/python
# slack-plexautoupdate
import os
import glob
import sys

# List & sort SBo
sboLocation = sys.path[0]
listBuilds = glob.glob(str(sboLocation) + "/plexmediaserver*.deb")
listBuilds.sort()

# List & sort final packages
listPackages = glob.glob("/tmp/plexmediaserver*")
listPackages.sort()

# Get last package and current based on the before last
lastVersion = listPackages[-1]

# Check if there were olders installs
try:
    currentVersion = listPackages[-2]
except:
    print "We assume it's your first vanilla install, no need to try an upgrade."
    sys.exit(0)


### Upgrade
print "Your current version is " + currentVersion
print "You just build " + lastVersion + ". Prepare for upgrade."

os.chdir("/tmp")
try:
    os.system("upgradepkg " + currentVersion + "%" + lastVersion)
except:
    # We assume you're already on the latest version if it fails. If not, investigate it.
    print "You're already on the latest version."


### Keep things clean with 5 versions
versionsToKeep = 5
listToClean = listPackages[:versionsToKeep]
buildsToClean = listBuilds[:versionsToKeep]

if len(listToClean) < versionsToKeep or len(buildsToClean) < versionsToKeep:
    print "No need to clean for now."

else:
    # From /tmp
    for el in listToClean:
        os.system("rm -f " + el)

    # do the same in SBo folder
    for el in buildsToClean:
        os.system("rm -f " + el)



print "|====================================|"
print "|slack-plexautoupdate execution done!|"
print "|====================================|"
