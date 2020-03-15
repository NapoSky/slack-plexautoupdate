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
currentVersion = listPackages[-2]


### Upgrade
print "Your current version is " + currentVersion
print "You just build " + lastVersion + ". Prepare for upgrade."

os.chdir("/tmp")
os.system("upgradepkg " + currentVersion + "%" + lastVersion)


### Keep things clean with 5 versions
versionsToKeep = 5
# From /tmp
listToClean = listPackages[:versionsToKeep]

for el in listToClean:
    os.system("rm -f " + el)


# do the same in SBo folder
buildsToClean = listBuilds[:versionsToKeep]

for el in buildsToClean:
    os.system("rm -f " + el)



print "|================================|"
print "|Your plexmediaserver is updated!|"
print "|================================|"
