#!/bin/bash

echo "Choose the Firefox release you wanna install/upgrade [1|2|3|4]:"
echo "1. Firefox Stable"
echo "2. Firefox Beta"
echo "3. Firefox Developer Edition"
echo "4. Firefox Nightly"
read -rp "> " CHOICE

ARCHI_SHORT=""
if  uname -m| grep -q "x86_64" ; then
	ARCHI_SHORT="64"
fi

if [ $CHOICE = 1 ]; then
	URL=$(wget -q -O - https://www.mozilla.org/en-US/firefox/all/ | egrep -o "href=.*?os=linux${ARCHI_SHORT}&amp;lang=en-US['"'"'"]" | sed -e 's/\&amp;/\&/g' -e 's/^href=//' -e 's/["'"'"']//g' )
	RELEASE="-stable"
elif [ $CHOICE = 2 ]; then
	RELEASE="-beta"
	URL=$(wget -q -O - https://www.mozilla.org/en-US/firefox/beta/all/ | egrep -o "href=.*?os=linux${ARCHI_SHORT}&amp;lang=en-US['"'"'"]" | sed -e 's/\&amp;/\&/g' -e 's/^href=//' -e 's/["'"'"']//g' )
elif [ $CHOICE = 3 ]; then
	RELEASE="-developer"
	URL=$(wget -q -O - https://www.mozilla.org/en-US/firefox/developer/all/ | egrep -o "href=.*?os=linux${ARCHI_SHORT}&amp;lang=fr['"'"'"]" | sed -e 's/\&amp;/\&/g' -e 's/^href=//' -e 's/["'"'"']//g' )
elif [ $CHOICE = 4 ]; then
	URL=$(wget -q -O - http://nightly.mozilla.org | egrep -o "href=.*?firefox.*?linux-${ARCHI}\.tar\.bz2['"'"'"]" | sed -e 's/^href=//' -e 's/["'"'"']//g')
	RELEASE="-nightly"
else
	exit 0
fi

if [ ! -d "/tmp/ff$RELEASE" ] ; then
	mkdir /tmp/ff$RELEASE
else
	rm -rf /tmp/ff$RELEASE/*
fi

if [ ! -d "/opt/firefox$RELEASE" ] 
then
	sudo mkdir /opt/firefox$RELEASE
fi

wget $URL -O /tmp/ff$RELEASE/ff$RELEASE.tar.bz2
sudo tar -C /opt/firefox$RELEASE/ -xvjf /tmp/ff$RELEASE/*.tar.bz2

if [ ! -f "/usr/local/bin/firefox$RELEASE" ] 
then
	sudo ln -s /opt/firefox$RELEASE/firefox/firefox /usr/local/bin/firefox$RELEASE
fi
