#!/bin/bash
# Copyright 2016 Kevin Froman and Duncan X. Simpson. See the license file for more information.

# Set lock file name
lock=".anonblog-LOCK"

if [ -f $lock ];
then
	echo "AnonBlog appears to already be running."
	echo ""
	echo "If it crashed last time, delete $lock."
	exit
fi

# Make sure we are operating in the scripts path
SCRIPT=$(readlink -f "$0")

SCRIPTPATH=$(dirname "$SCRIPT")
cd $SCRIPTPATH

if [ ! $(which shred 2>/dev/null) ]; then
  echo "You don't have source installed. Will now quit."
	exit 1
fi

source config/abconfig

# Check for dependencies
if [ ! $(which shred 2>/dev/null) ]; then
  echo "You don't have shred installed. You cannot use the private key encryption feature."
fi
if [ ! $(which nc 2>/dev/null) ]; then
	echo "You don't have netcat (nc) installed. Falling back to predefined port."
	randomPort=false
fi

export LD_LIBRARY_PATH="./lib"

if [ $(uname "-m") == "x86_64" ]; then
	TOR_EXECUTABLE="bin/tor64"
	BB_EXECUTABLE="bbserver64"
else
	TOR_EXECUTABLE="bin/tor"
	BB_EXECUTABLE="bbserver"
fi

# Get a random port number if randomPort is true (it is by default), if not use PORT set in the config.
if [ $randomPort == true ]; then
	while true
	do
		PORT=$(($RANDOM$RANDOM$RANDOM%65000+1024))
		nc -z 127.0.0.1 $PORT
		if [ $? == 1 ]; then
			break
		fi

	done
fi

sed -i.bak '2s/.*/HiddenServicePort 80 127.0.0.1:'$PORT'/' config/torrc
if [ $# == 1 ]; then
	COMMAND=$1
else
	COMMAND="help"
fi

if [ $COMMAND == "start" ]; then

	touch $lock

	echo "Starting AnonBlog..."
	echo ""


	if [ -f "./keys/private_key.aes" ];
	then
		while [ 1 == 1 ]
		do
			echo ""
			echo "Password to Decrypt Private Key:"
			openssl enc -d -aes-256-cbc -a -salt -in ./keys/private_key.aes -out ./keys/private_key
			echo ""
			if [ -f "./keys/private_key" ];
			then
				rm ./keys/private_key.aes
				echo "Key successfully decrypted."
				break
			fi
		done
	fi

	killall $BB_EXECUTABLE 2> /dev/null
	echo ""
	bin/$BB_EXECUTABLE $PORT ./site/ & disown
    BBPID=$(($!+2))
	echo "Your .onion address will be in the 'keys' folder, back it up if you care about it!"
	echo ""
	echo "Tor can take a minute or so to publish hidden services."
	echo ""
	echo "Internal port set to $PORT."
	echo ""
	echo "Started. Press Ctrl+C to exit."
	$TOR_EXECUTABLE --quiet -f config/torrc
	if [ $? != 0  ]; then
		echo "It seems Tor failed to start. Rerunning with output enabled."
		$TOR_EXECUTABLE -f config/torrc
	fi

	if [[ $encryptPrivate == true ]]
	then
		echo ""
		echo "Password to encrypt private key (DO NOT LOSE IT!)."
		echo ""
		openssl enc -aes-256-cbc -a -salt -in ./keys/private_key -out ./keys/private_key.aes
		if [ -f "./keys/private_key.aes" ];
		then
			shred ./keys/private_key
			rm ./keys/private_key
			echo 'Key successfuly encrypted'
		else
			echo 'There seems to have been an issue encrypting the private key. File remains unencrypted.'
		fi
	fi

	# Kill web server, delete lock file.

	kill $BBPID

	rm $lock

elif [ $COMMAND == "help" ]; then
	echo "Syntax: ./main.sh [start]"
	echo "For more help see the README."
else
	echo "Unrecognized command. Run with no args for help."
fi
