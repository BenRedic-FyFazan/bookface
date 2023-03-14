#! /bin/bash
#ssh ubuntu@192.168.128.138 "/home/ubuntu/stopCock.sh"

## SJEKK AT VM ER OPPE
vm_status_backup=$(openstack server show backup -f value -c status)  # Variabel for vmstatus
vm_status_DB=$(openstack server show db2_test -f value -c status) 
echo $vm_status_backup
echo $vm_status_DB

###
# Forslag -> 			1. er backup online? hvis ikke, slå på
#				2. Mount nettverksdisk
#				3. Gå ut av produksjon
#				4. Kontrollsjekker
#				5. Start backup
#				6. Går inn i produksjon
#				7. Kontrollsjekker
#				8. Slå av backup
###



## Tests if volume is mounted, mounts volume if not mounted
mountState=$(ssh ubuntu@192.168.129.25 "mount | grep 'vdb on /mnt'")
if ! [[ "$mountState" =~ /dev/vdb\ on\ /mnt ]]; then
        echo "/dev/vdb is not mounted on /mnt, trying to mount..."
        ssh ubuntu@192.168.129.25 "sudo mount /dev/vdb /mnt"

        if [ $? -eq 0 ]
        then 
                echo "Success! /dev/vdb succesfully mounted on /mnt"
        else 
                echo "FAIL! unsuccesful mount, quitting task..."
                exit
        fi
else 
        echo "/dev/vdb already mounted on /mnt, continuing..."
fi


## Sjekker at både DB og Backup VM'er er aktive
if [ "$vm_status_backup" = "ACTIVE" ] && [ "$vm_status_DB" = "ACTIVE" ]
then
	echo "Serverne er oppe!"

	## SJEKK AT COCKROACH PROSESS KJØRER
	cock_status=$(ssh ubuntu@192.168.128.138 "ps -C cockroach -o pid=") # variabel for status på cockroachdb

	if [ -n "$cock_status" ]

		then
 
		## STOPCOCK
		exit_value=$(ssh ubuntu@192.168.128.138 "/home/ubuntu/stopCock.sh" | tail -n 1)
		if [ "$exit_value" = "ok" ] 
			then
	 			echo "success!"
			else
	 			echo "failure"
		fi

	else 
		echo "Cock is not running"
	fi
	## COMPRESSING DATABASE
	ssh ubuntu@192.168.128.138 "sudo tar czf /home/ubuntu/bfdata_backup.tgz /bfdata"
	if [ $? -eq 0 ]
		then 
			echo "Compression successfull"
		else
			echo "Compression unsuccesfull"
	fi 

	## SCP BACKUP ARCHIVE
	ssh ubuntu@192.168.129.25 "scp -i /home/ubuntu/id_rsa ubuntu@192.168.128.138:/home/ubuntu/bfdata_backup.tgz /home/ubuntu"
	if [ $? -eq 0 ]
                then 
                        echo "SCP successfull"
                else
                        echo "SCP FAILED!"
        fi 

	## STARTCOCK
	if [ "$exit_value" = "ok" ]
		then
			## Legger til timeout så ssh connection blir terminert.
		 	echo 
			timeout 10s ssh ubuntu@192.168.128.138 '/home/ubuntu/startCock.sh'
			echo "Cockroach started succesfully!"
		else 
				echo "CockroachDB not started! stopCock.sh did not execute succesfully"
		fi

else
	echo "En av serverne er nede"

fi

## Unmounts volume
echo "unmounting /mnt..."
ssh ubuntu@192.168.129.25 "sudo umount /mnt"
