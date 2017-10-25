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
	RELEASE="-stable"
	URL=$(wget -q -O - https://www.mozilla.org/en-US/firefox/all/ | egrep -o "href=.*?os=linux${ARCHI_SHORT}&amp;lang=fr['"'"'"]" | sed -e 's/\&amp;/\&/g' -e 's/^href=//' -e 's/["'"'"']//g' )
elif [ $CHOICE = 2 ]; then
	RELEASE="-beta"
	URL=$(wget -q -O - https://www.mozilla.org/en-US/firefox/beta/all/ | egrep -o "href=.*?os=linux${ARCHI_SHORT}&amp;lang=fr['"'"'"]" | sed -e 's/\&amp;/\&/g' -e 's/^href=//' -e 's/["'"'"']//g' )
elif [ $CHOICE = 3 ]; then
	RELEASE="-developer"
	URL=$(wget -q -O - https://www.mozilla.org/en-US/firefox/developer/all/ | egrep -o "href=.*?os=linux${ARCHI_SHORT}&amp;lang=fr['"'"'"]" | sed -e 's/\&amp;/\&/g' -e 's/^href=//' -e 's/["'"'"']//g' )
elif [ $CHOICE = 4 ]; then
	URL=$(wget -q -O - https://www.mozilla.org/en-US/firefox/nightly/all/ | egrep -o "href=.*?os=linux${ARCHI_SHORT}&amp;lang=fr['"'"'"]" | sed -e 's/\&amp;/\&/g' -e 's/^href=//' -e 's/["'"'"']//g' )
	RELEASE="-nightly"
else
	exit 0
fi

if [ ! -d "/opt/firefox$RELEASE" ]
then
	sudo mkdir /opt/firefox$RELEASE
fi

wget $URL -O /tmp/ff$RELEASE.tar.bz2
sudo tar --strip 1 -C /opt/firefox$RELEASE/ -xvjf /tmp/ff$RELEASE.tar.bz2

MOZICONPATH=/opt/firefox$RELEASE/browser/icons/mozicon128.png
MOZICONDESTPATH=/usr/share/icons/hicolor/128x128/apps/firefox$RELEASE.png

echo $MOZICONPATH $MOZICONDESTPATH
if ! cmp $MOZICONPATH $MOZICONDESTPATH >/dev/null 2>&1
then
	echo "mozicon128.png are not the same. Update ..."
  sudo ln -sf /opt/firefox$RELEASE/browser/icons/mozicon128.png /usr/share/icons/hicolor/128x128/apps/firefox$RELEASE.png
fi
