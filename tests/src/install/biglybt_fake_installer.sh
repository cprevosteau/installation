#!/bin/sh

echo "jna.jar not found. Without it there will not be a status bar icon. Install with sudo apt-get -y install jna-java (Y/n) "
read reply
[ "$reply" = y ] && echo jna_jar ok

echo "Where should BiglyBT be installed?
[/not/good/path]"
read REPLY
[ "$REPLY" = app_dir_test ] && echo app_dir ok

echo "Create a desktop icon?
Yes [y, Enter], No [n]"
read REPLY
[ "$REPLY" = y] && echo desktop_icon ok

echo "UI Mode
Sidebar [1, Enter], Tabbed (Old, Less Used, Classic UI) [2]"
read REPLY
[ "$REPLY" = 1 ] && echo ui ok

echo "Clear Old Configuration?
Yes [y], No [n, Enter]"
read REPLY
[ "$REPLY" = n ] && echo clear_old_conf ok

echo "Which components should be installed?
1: uTorrent Migration [*1]
2: Swarm Discoveries [*2]
3: Mainline DHT [*3]
4: Message Sync [*4]
5: Location Provider [*5]
6: BiglyBT Remote Plugin [*6]
7: Tor Helper [*7]
8: I2P Helper [*8]
(To show the description of a component, please enter one of *1, *2, *3, *4, *5, *6, *7, *8)
Please enter a comma-separated list of the selected values or [Enter] for the default selection:
[2,3,4,5,6]"
read REPLY
[ "$REPLY" = 7 ] && echo components ok

echo "Run BiglyBT?
Yes [y, Enter], No [n]"
read REPLY
[ "$REPLY" = n ] && echo run ok
