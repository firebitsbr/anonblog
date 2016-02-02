source config
sed -i.bak '2s/.*/HiddenServicePort 80 127.0.0.1:'$PORT'/' torrc
if [ $# == 1 ]; then
	COMMAND=$1
else
	COMMAND="help"
fi

if [ $COMMAND == "start" ]; then
	killall bbserver 2> /dev/null
	echo "Starting..."
	./bbserver $PORT ./site/
	pgrep bbserver > /dev/null
	RESULT=$?
	if [ ! "${RESULT}" -eq "0" ]; then
		echo "It seems the server failed to start. Please try again."
		exit
	fi
	echo "Started. Press Ctrl+C to exit."
	./tor --quiet -f torrc
	if [ $? == 255  ]; then
		echo "It seems Tor failed to start. Rerunning with output enabled."
		./tor -f torrc
	fi
	killall bbserver
elif [ $COMMAND == "help" ]; then
	echo "Syntax: ./main.sh [start]"
	echo "For more help see the README."
else
	echo "Unrecognized command. Run with no args for help."
fi
