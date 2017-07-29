#!/bin/bash
filepath=$(cd "$(dirname "$0")"; pwd)
binPath=$filepath/_/usr/bin/
cd $filepath/defaults/&&make
cp $filepath/defaults/.theos/obj/defaults $binPath

cd $filepath/keychain/&&make
ldid -Sentitlements.xml $filepath/keychain/.theos/obj/keychain
cp $filepath/keychain/.theos/obj/keychain $binPath

cp $filepath/Clutch/Clutch $binPath

cd $filepath&&dpkg-deb -bZ gzip  $filepath/_ cycTools.deb