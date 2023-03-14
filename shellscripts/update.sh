#!/bin/bash

echo "Program run at: $(date '+%F_%H:%M:%S')" >> ~/config/tempfil.txt;

#Pushes up the config files to the other webservers
for SRV in $(grep -v "^#" ~/config/srvlist.txt); do
	if ping -c 5 $SRV &> /dev/null;
		then
			NAME=$(openstack server list | grep $SRV | cut -d "|" -f 2 | tr -d ' ');
			echo "Webserver $SRV er oppe" >> ~/config/tempfil.txt; 
			ssh ubuntu@$SRV "cd ~/bookface; git fetch; git pull;" >> ~/config/tempfil.txt;
		else
			NOW=`date '+%F_%H:%M:%S'`;
			#NAME=$(openstack server list | grep $SRV | cut -d "|" -f 2 | tr -d ' ');
			echo "Webserver $SRV er nede. Tid/dato: $NOW" >> ~/config/error.txt;
			#openstack reboot $NAME(?)
	fi
done
