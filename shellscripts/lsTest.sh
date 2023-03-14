#!/bin/bash

# Sources/fetches the functions in the base-script
source ~/bookface/shellscripts/base.sh

# Check for in the return value 0 to the ls command
# with the first parameter sendt to the script
if(ls $1 2> /dev/null)
then
	#If the file is found
	ok "File found";
else
	#If the file is not found
	error "File not found";
fi

