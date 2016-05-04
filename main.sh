# Copyright 2016 Kevin Froman and Duncan X. Simpson. See the license file for more information.
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
	killall bbserver 2> /dev/null
	echo "Starting..."
	echo ""
	bin/bbserver $PORT ./site/
	pgrep bbserver > /dev/null
	RESULT=$?
	if [ ! "${RESULT}" -eq "0" ]; then
		echo "It seems the server failed to start. Please try again."
		exit
	fi
	echo "Your .onion address will be in the 'keys' folder, if you care about it, remember to safely back it up!"
	echo ""
	echo "Tor can take a minute or so to publish hidden services."
	echo ""
	echo "Started. Press Ctrl+C to exit."
	$TOR_EXECUTABLE --quiet -f config/torrc
	if [ $? != 0  ]; then
		echo "It seems Tor failed to start. Rerunning with output enabled."
		$TOR_EXECUTABLE -f config/torrc
	fi
	killall bbserver
elif [ $COMMAND == "help" ]; then
	echo "Syntax: ./main.sh [start]"
	echo "For more help see the README."
else
	echo "Unrecognized command. Run with no args for help."
fi
