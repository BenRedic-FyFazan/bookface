#!/bin/bash

#Run this to gurarantee that openstack commands can be run
source /home/ubuntu/DCSG2003_V23_group44-openrc.sh

#Returns the servers names and their status to variable
SERVER_DATA=$(openstack server list -f value -c Name -c Status)
WEBHOOK="https://discord.com/api/webhooks/1072501843185369169/FKARYQMNnnkV29FoZLMNGnocDlhsEwFYQwIl9hcV_-okW0w2qeKnawRuvL4fWXRrrGQP"

#Posts a message on discord:
discMsg (){
	curl -X POST -H "Content-Type: application/json" -d '{"content": "'"$1"'"}' $WEBHOOK;
}


#Reboots a instance given it's name:
rebootVM(){
	local INDEX=1
	while [ "$(openstack server show "$1" -f value -c status)" == "SHUTOFF" ]; do
		discMsg "Trying to reboot: $1... Try nr: $INDEX" 
		openstack server start "$1"
		((INDEX=INDEX+1))
	done
	discMsg "$1 is now rebooted"

}

#Goes trough each element in SERVER_DATA and checks status:
while read -r Name Status; do
	case $Status in
		"ACTIVE")
			#discMsg "$Name is online!"
		;;
		
       		"SHUTOFF")
			if [ "$Name" != "backup" ]; then
				rebootVM "$Name"
			fi
		;;

		*)
			echo "No check for status: $Status" 1>&2
		;;
	esac

	#if [[$Name == *"db_node"* ]]; then
	#	IPADDR=$(openstack server show $Name -f value -c addresses | grep -o -P "192(\.\d{1,3}){3}")
	#
	#	ssh user@$IPADDR "echo \"do something\""
	#fi

done <<< "$SERVER_DATA"


