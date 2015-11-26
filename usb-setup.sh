#!/bin/bash

#source folders
retropieFolder=/home/pi/RetroPie
configFolder=/opt/retropie/configs
emustationFolder=/home/pi/.emulationstation

#target folders
usbRoot=/media/usb0/retropie-data
retropieSubDir=RetroPie
configSubDir=configs
emustationSubDir=emulationstation

function copy {
	echo 'Copying files to USB device...'
	cp -R $retropieFolder $usbRoot/$retropieSubDir
	cp -R $configFolder $usbRoot/$configSubDir
	cp -R $emustationFolder $usbRoot/$emustationSubDir
	echo 'Done.'
}

function backupAndLink {
	echo 'Configuring '$1
	if [ -d $1 ];
	then
		if [ -d $2 ];
		then
			mv $1 $1-org
			ln -nfs $2 $1
		else
			echo 'USB target folder ' $2 'does not exist.'
		fi
	else
		echo 'Source folder ' $1 'does not exist.'
	fi
}

function unlinkAndRestore {
	echo 'Restoring '$1
	if [ -L $1 ];
	then
		rm $1
		mv $1-org $1
	fi
}

mkdir -p $usbRoot

if [ "$1" == "copy" ];
then
	copy
elif [ "$1" == "unlink" ];
then
	echo 'Restoring original files on SD card.'
	unlinkAndRestore $retropieFolder
	unlinkAndRestore $configFolder
	unlinkAndRestore $emustationFolder
else
	echo 'Configuring USB device for use with retropie.'
	backupAndLink $retropieFolder $usbRoot/$retropieSubDir
	backupAndLink $configFolder $usbRoot/$configSubDir
	backupAndLink $emustationFolder $usbRoot/$emustationSubDir
fi
