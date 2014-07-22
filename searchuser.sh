#!/bin/bash

#To use this seach as follows:
# ./searchuser.sh <emailid>
#It will give an output of all the groups that user belongs to

ldapsearch -x | grep cn= | awk -F "=|," '{print $2}' >> groups.txt

echo "$1" >> usergroups.txt

while read line
do
	searchresult=$(ldapsearch -x cn=$line | grep maildrop: | grep $1 | awk '{print $2}')
	if [ -n "$searchresult" ]; then
		echo "	$line"
		echo " $line" >> usergroups.txt
	fi
done < groups.txt

rm groups.txt

echo "The output file is mailed"

cp usergroups.txt /tmp/
(uuencode /tmp/usergroups.txt usergroups.txt; echo "PFA the list of groups a user belongs to") | mailx -s "Groups a user belongs to" -a "From:toadmin@abc.
com" "user@abc.com"
