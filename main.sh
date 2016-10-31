#!/bin/bash
# Copyright 2016 Kevin Froman and Duncan X. Simpson. See the license file for more information

# Set lock file name
lock=".anonblog-LOCK"

if [ -f $lock ];
then
	echo "AnonBlog appears to already be running. ¯\_(ツ)_/¯"
	echo ""
	echo "If it crashed last time, delete $lock."
	exit
fi

# Make sure we are operating in the scripts path
SCRIPT=$(readlink -f "$0")

SCRIPTPATH=$(dirname "$SCRIPT")
cd $SCRIPTPATH

if [ ! $(which shred 2>/dev/null) ]; then
  echo -e "${RED}You don't have source installed. Will now quit${NC}."
	exit 1
fi

source config/abconfig

# Colors config
if [ $colors == true ]; then
	RED='\033[0;31m'
	NC='\033[0m' # No Color
	GREEN='\033[0;32m'
else
	RED=''
	NC=''
	GREEN=''
fi

# Check for dependencies
if [ ! $(which shred 2>/dev/null) ]; then
  echo -e "${RED}You don't have shred installed. You cannot use the private key encryption feature${NC}."
	encryptPrivate=false;
fi
if [ ! $(which openssl 2>/dev/null) ]; then
	echo -e "${RED}You don't have openssl installed. You cannot use the private key encryption feature${NC}."
	encryptPrivate=false;
	opensslInstalled=false;
else
	opensslInstalled=true;
fi
if [ ! $(which nc 2>/dev/null) ]; then
	echo "${RED}You don't have netcat (nc) installed. Falling back to predefined port${NC}."
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
		if [[ $opensslInstalled == false ]]; then
			echo "${RED}Private key appears encrypted, but you don't have openssl installed. Exiting${NC}."
			rm $lock
			exit 1
		fi
		while [ 1 == 1 ]
		do
			echo ""
			echo "Password to Decrypt Private Key:"
			openssl enc -d -aes-256-cbc -a -salt -in ./keys/private_key.aes -out ./keys/private_key
			if [ $? != 0  ]; then
				echo -e "${RED}Failed to decrypt file.${NC}"
				rm  keys/private_key 2> /dev/null
			else
				echo ""
				if [ -f "./keys/private_key" ];
				then
					rm ./keys/private_key.aes
					echo -e "${GREEN}Key successfully decrypted${NC}."
					break
				fi
			fi
		done
	fi

	killall $BB_EXECUTABLE 2> /dev/null
	echo ""
	bin/$BB_EXECUTABLE $PORT ./site/ & disown
    BBPID=$(($!+2))


	if [ -f "keys/hostname" ];
	then
		printf "${GREEN}Hidden service at${NC}: "; cat keys/hostname
	else
		echo "Your .onion address will be in the 'keys' folder, back it up if you care about it!"
	fi
	echo ""
	echo "Tor can take a minute or so to publish hidden services."
	echo ""
	echo "HTTP server internal port set to $PORT. View your site locally at http://127.0.0.1:$PORT"
	echo ""
	echo -e "${GREEN}Started. Press Ctrl+C to exit${NC}."
	$TOR_EXECUTABLE --quiet -f config/torrc
	if [ $? != 0  ]; then
		echo "It seems Tor failed to start. Rerunning with output enabled."
		$TOR_EXECUTABLE -f config/torrc
	fi

	while [ 1 == 1 ]
	do
		if [[ $encryptPrivate == true ]]
		then
			echo ""
			echo -e "Password to encrypt private key ${RED}(DO NOT LOSE IT!)${NC}."
			echo ""
			openssl enc -aes-256-cbc -a -salt -in ./keys/private_key -out ./keys/private_key.aes
			if [ -f "./keys/private_key.aes" ];
			then
				shred ./keys/private_key
				rm ./keys/private_key
				echo -e "${GREEN}Key successfuly encrypted${NC}."
				break
			else
				if [ -f "./keys/private_key" ];
				then
					echo -e "${RED}There seems to have been an issue encrypting the private key. File remains unencrypted${NC}."
						read -p "Try again (y/n)?" again
						if [[ $again == 'y' || $again == 'Y' ]]
						then
							echo "Trying again."
						else
							echo -e "Exiting. ${RED}Private key remains unecrypted${NC}."
							break
						fi
				else
					echo -e "${RED}There seems to have been an issue encrypting the private key${NC}."
				fi
			fi
		else
			break
		fi
	done

	# Kill web server, delete lock file.

	kill $BBPID

	rm $lock
elif [ $COMMAND == "help" ]; then
	echo "Syntax: ./main.sh [start]"
	echo "For more help see the README."
else
	echo "Unrecognized command. Run with no args for help."
fi
exit 0
