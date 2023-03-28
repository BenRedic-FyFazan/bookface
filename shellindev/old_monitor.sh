#!/bin/bash

#Run this to gurarantee that openstack commands can be run
source /home/ubuntu/DCSG2003_V23_group44-openrc.sh;

#Returns the servers names and their status to variable
SERVER_DATA=$(openstack server list -f value -c Name -c Status);
WEBHOOK="https://discord.com/api/webhooks/1072501843185369169/FKARYQMNnnkV29FoZLMNGnocDlhsEwFYQwIl9hcV_-okW0w2qeKnawRuvL4fWXRrrGQP"

function checkStatus {
		echo "$Name er nede";

		curl -X POST -H "Content-Type: application/json" -d '{"content": "Trying to restart: '$Name'"}' $WEBHOOK;
		openstack server start "$Name";
		
		SERVER_STATUS=$(openstack server show "$Name" -f value -c status);
		
		if [ $SERVER_STATUS == "ACTIVE" ]; then
			echo "'$Name' er oppe!";
		fi

		while [ $SERVER_STATUS != "ACTIVE" ];	do
				sleep 1;
				SERVER_STATUS=$(openstack server show "$Name" -f value -c status);
				curl -X POST -H "Content-Type: application/json" -d '{"content": "'$Name' har status: '$SERVER_STATUS'"}' $WEBHOOK;
		done
		
		echo "$Name has booted...";

}

#Goes trough each element in SERVER_DATA and checks status
while read -r Name Status; do
	case $Status in
		 "ACTIVE")
			echo "$Name is up";
		;;
		
       		"SHUTOFF")
			checkStatus;
		;;

		*)
			echo "No check for status: $Status" >&2;
		;;
	esac
done <<< $SERVER_DATA


