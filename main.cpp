#include <iostream>
#include <stdlib.h>
#include <string>
using namespace std;

int main(int argc, char* argv[]) {
	string command;
	if (argc == 2)
	{
	command = argv[1];
	}
	else
	{
	command = "help";
	}
	
	// start tor + site
	if (command == "start")
	{
	cout << "Starting Server. Press ctrl c to stop\n";
	system("./bbserver 8000 ./site/");
	system("./tor --quiet -f torrc");
	system("pkill bbserver");
	}
	/*
	else if (command == "stop")
	{
	system("pkill tor >> main.log");
	cout << "Stopping server\n";
	}
	*/
	else if (command == "help")
	{
	cout << "this is help\n";
	}
	
   return 0;
} 
