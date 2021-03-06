#!/bin/bash
#
# Upgrade script for a LabKey Remote Pipeline Server
# This script can be used to upgrade a LabKey Remote Pipeline Server installed
# on a Linux, Solaris or MacOSX server.
#
# The LabKey Remote Pipeline Server is a part of the LabKey Server Enterprise Pipeline
# See https://www.labkey.org/wiki/home/Documentation/page.view?name=InstallEnterprisePipeline
# for more information 
#
# If you need support, please post a message to the LabKey Support boards at 
# https://www.labkey.org/project/home/Server/Forum/begin.view?
#
# The upgrade script will do the following:
#  1) Verify the LabKey Distribution is ready to be installed
#  2) Uninstall the previous version of LabKey 
#  3) Install the new version of LabKey Server 
#
# This script requires the unzipped distribution directory name to be entered on 
# the command line. For example:
#   upgrade-remote-pipeline.sh LabKey13.3-r28123-bin


# Variables
# -------------------------------------------------------
# Change these variables for your server
#
# labkey_distdir is the directory which contains the LabKey distribution 
# labkey_home is the directory which will contain the the labkeywebapp
#   modules directories
# LABKEY_USER is the user which will own the files in the LABKEY_HOME
#   directory.
# LABKEY_GROUP is the group which will own the files in the LABKEY_HOME
#   directory.

LABKEY_HOME='/labkey/labkey'
LABKEY_DISTDIR='/labkey/src/labkey'
DATE=$(date +20%y%m%d%H%M)
LABKEY_USER='labkey'
LABKEY_GROUP='labkey'


# Test if command-line arg present
if [ -n "$1" ]; then
  dist=$LABKEY_DISTDIR/$1
else  
  echo "You must specify the name of the LabKey distribution."
  echo "For example, upgrade-remote-pipeline.sh LabKey12.1-20297-bin"
  exit 1
fi

if [ -d $dist ]; then
  # directory exists
  test=1
else
  echo "The distribution directory, $dist , does not exist" 
  exit 1
fi


echo ' '
echo ' '
echo '-------------  Start the Upgrade at ' `date` 
echo ' '

# Remove all the LabKey files from previous version. 
echo 'Begin the Installation Process: '
echo '   --- Remove all files from previous version '
rm -rf $LABKEY_HOME/modules
rm -rf $LABKEY_HOME/labkeywebapp
rm -rf $LABKEY_HOME/pipeline-lib
rm -rf $LABKEY_HOME/labkeyBootstrap.jar

echo ' ' 
echo '   -- Install the new bits ' 
cd $dist

cp -R modules $LABKEY_HOME
cp -R labkeywebapp $LABKEY_HOME
cp -R pipeline-lib $LABKEY_HOME
cp -f tomcat-lib/labkeyBootstrap.jar $LABKEY_HOME/labkeyBootstrap.jar


echo ' ' 
echo '   --- Change Permission of the newly installed files ' 
chown -R $LABKEY_USER:$LABKEY_GROUP $LABKEY_HOME


echo ' '
echo '----------------  The installation is completed at ' `date`
echo ' '

