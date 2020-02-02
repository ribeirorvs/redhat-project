#!/bin/sh

AUTHORS="Rodrigo Vitor Ribeiro"
PROJECT="Red Hat Project - To Do list"
PRODUCTS="Red Hat EAP 7.3"
TARGET=./target
JBOSS_HOME=$TARGET/EAP-7.3.0
SERVER_DIR=$JBOSS_HOME/standalone/deployments
SERVER_CONF=$JBOSS_HOME/standalone/configuration/
SERVER_BIN=$JBOSS_HOME/bin
SRC_DIR=./installs
SUPPORT_DIR=./support
EAP=jboss-eap-7.3.0.Beta-installer.jar
VERSION=7.3
PROJECT_GIT_REPO=https://github.com/ribeirorvs/redhat-project-repo

# wipe screen.
clear

echo
echo "#################################################"
echo "##                                             ##"
echo "## Setting up the application                  ##"
echo "##                                             ##"
echo "##    ####  #### ###     #   #  ###  #####     ##"
echo "##    #   # #    #  #    #   # #   #   #       ##"
echo "##    ####  ##   #   #   ##### #####   #       ##"
echo "##    # #   #    #  #    #   # #   #   #       ##"
echo "##    #  #  #### ###     #   # #   #   #       ##"
echo "##                                             ##"
echo "##                                             ##"
echo "## brought to you by                           ##"
echo "##    ${AUTHORS}                    ##"
echo "##                                             ##"
echo "#################################################"
echo
echo

if [ -r $SRC_DIR/$EAP ] || [ -L $SRC_DIR/$EAP ]; then
	 echo Product sources are present...
	 echo
else
	echo Need to download $EAP package from http://developers.redhat.com
	echo and place it in the $SRC_DIR directory to proceed...
	echo
	exit
fi


# Remove the old JBoss instance, if it exists.
if [ -x $JBOSS_HOME ]; then
	echo "  - removing existing JBoss product..."
	echo
	rm -rf $JBOSS_HOME
fi

# Run installers.
echo "Provisioning JBoss EAP now..."
echo
java -jar $SRC_DIR/$EAP ./support/auto.xml


if [ $? -ne 0 ]; then
	echo
	echo Error occurred during JBoss EAP installation!
	exit
fi

echo "  - setting up the projects..."
echo

echo "  - cloning the project's Git repo from: $PROJECT_GIT_REPO"
echo

rm -rf ./target/tmp && git clone -b version-2.5 $PROJECT_GIT_REPO.git ./target/tmp

echo "  - deploying the application..."
echo

mvn clean install -f ./target/tmp/todo-list
cp ./target/tmp/todo-list/target/todo-list.war $SERVER_DIR

echo "  - clean up..."
echo

rm -rf ./target/tmp

echo "You can now start the application with $SERVER_BIN/standalone.sh"
echo
echo "Look at http://localhost:8080/todo-list"
echo
echo "JBoss user:	eapAdmin"
echo "      password:	RedHat#1"
echo

echo "Setup Complete."
echo
