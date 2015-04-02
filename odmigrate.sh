#!/bin/bash
INPUT=student_list.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }

# set the starting ID to a number higher than the highest current userID
ID=1000

while read gradyear fname lname uname
do
 echo "Creating: $fname $lname"
 dscl -u diradmin -P your_dir_admin_password /LDAPv3/127.0.0.1 -create /Users/$uname
 echo "Unique ID"
 dscl -u diradmin -P your_dir_admin_password /LDAPv3/127.0.0.1 -create /Users/$uname UniqueID $ID
 echo "fname"
 dscl -u diradmin -P your_dir_admin_password /LDAPv3/127.0.0.1 -create /Users/$uname FirstName $fname
 echo "lname"
 dscl -u diradmin -P your_dir_admin_password /LDAPv3/127.0.0.1 -create /Users/$uname LastName $lname
 echo "real name"
 dscl -u diradmin -P your_dir_admin_password /LDAPv3/127.0.0.1 -create /Users/$uname RealName "$fname $lname"
 echo "primary group"
 dscl -u diradmin -P your_dir_admin_password /LDAPv3/127.0.0.1 -create /Users/$uname PrimaryGroupID 1026
 echo "home dir"
 dscl -u diradmin -P your_dir_admin_password /LDAPv3/127.0.0.1 -create /Users/$uname NFSHomeDirectory /Users/$uname
 echo "password"
 dscl -u diradmin -P your_dir_admin_password /LDAPv3/127.0.0.1 -passwd /Users/$uname "$uname"
 echo "comment"
 dscl -u diradmin -P your_dir_admin_password /LDAPv3/127.0.0.1 -create /Users/$uname Comment "$gradyear"
 ((ID++))
 echo $ID
done < $INPUT
IFS=$OLDIFS
