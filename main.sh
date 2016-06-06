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


source config/abconfig

export LD_LIBRARY_PATH="./lib"
if [ $(uname "-m") == "x86_64" ]; then
	TOR_EXECUTABLE="bin/tor64"
else
	TOR_EXECUTABLE="bin/tor"
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
	
	# Detect if Anonblog should set iptables firewall rules to block other ips from accessing the server

	if [[ $blockOther == true ]]
	then
		echo "Iptables will protect your server, you may need to enter your root password."
		sudo iptables -N anonblog > /dev/null
		RESULT=$?
		if [[ "${RESULT}" -eq "1" ]]
		then
			echo "Iptables rules already set."
		else
			echo "Setting iptables rules."
			sudo iptables -A anonblog --src 127.0.0.1 -j ACCEPT
			sudo iptables -A anonblog -j DROP
			sudo iptables -I INPUT -m tcp -p tcp --dport $PORT -j anonblog
		fi
	else
		echo "WARN: Allowing other IPs can be dangerous. See docs for more information."
	fi

	killall bbserver 2> /dev/null
	echo ""
	bin/bbserver $PORT ./site/
	pgrep bbserver > /dev/null
	RESULT=$?
	if [ ! "${RESULT}" -eq "0" ]; then
		echo "It seems the server failed to start. Please try again."
		exit
	fi
	echo "Your .onion address will be in the 'keys' folder, back it up if you care about it!"
	echo ""
	echo "Tor can take a minute or so to publish hidden services."
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
			echo 'There seems to have been an issue encrypting the private key. File remains unencrypted'
		fi
	fi
	
	# Kill web server, delete lock file.

	killall bbserver

	rm $lock

elif [ $COMMAND == "help" ]; then
	echo "Syntax: ./main.sh [start]"
	echo "For more help see the README."
else
	echo "Unrecognized command. Run with no args for help."
fi
