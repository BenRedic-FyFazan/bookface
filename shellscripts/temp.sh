#! /bin/bash

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



## Unmounts volume
echo "Backup complete, unmounting /mnt..."
ssh ubuntu@192.168.129.25 "sudo umount /mnt"
