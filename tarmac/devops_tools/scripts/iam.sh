#!/bin/bash
#
#Prerequisites:
#brew install coreutils on MAC
#jq
#adjust $DATECMD variable if you are using MAC or Linux
#adjust $DAYS variable to your needs
#
# set -xe
function deleteKeys {
	for user in ${USERS}; do
		should_delete_key="no"
		for key in $(aws iam list-access-keys --user-name $user --output text | grep Active | cut -f2); do
			if [[ $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $9}') == "true" && $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $14}') == "true" ]]; then
				if [[ $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $10}' | awk -F 'T' '{print $1}' | ${DATECMD} -f - +%s ) -lt $(${DATECMD} --date "${DAYS} days ago" +%s) ]]; then
					echo "User $user has one access key older than ${DAYS} days."
				elif [[ $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $15}' | awk -F 'T' '{print $1}' | ${DATECMD} -f - +%s ) -lt $(${DATECMD} --date "${DAYS} days ago" +%s) ]]; then
					echo "User $user has one access key older than ${DAYS} days."
					echo "Do you want to delete Access Key for user $user? (y/n)"
					read response
					if [[ $response == "y" ]]; then
						should_delete_key="yes"
					fi
				fi
			elif [[ $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $9}') == "false" && $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $14}') == "true" ]]; then
				if [[ $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $15}' | awk -F 'T' '{print $1}' | ${DATECMD} -f - +%s) -lt $(${DATECMD} --date "${DAYS} days ago" +%s) ]]; then
					echo "User $user has an access key older than ${DAYS} days."
					echo "Do you want to delete Access Key for user $user? (y/n)"
					read response
					if [[ $response == "y" ]]; then
						should_delete_key="yes"
					fi
				fi
			elif [[ $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $9}') == "true" && $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $14}') == "false" ]]; then
				if [[ $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $10}' | awk -F 'T' '{print $1}' | ${DATECMD} -f - +%s) -lt $(${DATECMD} --date "${DAYS} days ago" +%s) ]]; then
					echo "User $user has an access key older than ${DAYS} days."
					echo "Do you want to delete Access Key for user $user? (y/n)"
					read response
					if [[ $response == "y" ]]; then
						should_delete_key="yes"
					fi
				fi
			elif [[ $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $9}') == "false" && $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $14}') == "false" ]]; then
				echo "User $user has no active access keys"
			else
				echo "User $user is strange #######???"
			fi
		done
		if [[ $should_delete_key == "yes" ]]; then
			echo "Deleting Access Keys for user $user"
			aws iam delete-access-key --access-key-id $key --user-name $user
			echo -e "${GREEN}Keys have been deleted for user $user${NC}"
		else
			echo "No Access Keys were deleted for user $user"
		fi
	done
}

function rotatePassword {
	for user in ${onlyUSERS}; do
		echo "Do you want to rotate password for user $user? (y/n)"
		read response
		if [[ $response == "y" ]]; then
			echo -e "${GREEN}Rotating Password for user $user${NC}"
			aws iam update-login-profile --user-name $user --password-reset-required --password $NEW_PASSWORD
			echo -e "New password for user $user is: ${GREEN}${NEW_PASSWORD}${NC}"
		else 
			echo "Going to next user... "
		fi
	done
}

function listKeys {
	for user in ${USERS}; do
			if [[ $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $9}') == "true" && $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $14}') == "true" ]]; then
				if [[ $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $10}' | awk -F 'T' '{print $1}' | ${DATECMD} -f - +%s ) -lt $(${DATECMD} --date "${DAYS} days ago" +%s) ]]; then
					echo -e "${RED}User $user has an access key older than ${DAYS} days.${NC}"
				elif [[ $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $15}' | awk -F 'T' '{print $1}' | ${DATECMD} -f - +%s ) -lt $(${DATECMD} --date "${DAYS} days ago" +%s) ]]; then
					echo -e "${RED}User $user has an access key older than ${DAYS} days.${NC}"
				else
					echo -e "${GREEN}User $user has valid keys yet${NC}"
				fi
			elif [[ $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $9}') == "false" && $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $14}') == "true" ]]; then
				if [[ $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $15}' | awk -F 'T' '{print $1}' | ${DATECMD} -f - +%s) -lt $(${DATECMD} --date "${DAYS} days ago" +%s) ]]; then
					echo -e "${RED}User $user has an access key older than ${DAYS} days.${NC}"
				else
					echo -e "${GREEN}User $user has valid keys yet${NC}"
				fi
			elif [[ $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $9}') == "true" && $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $14}') == "false" ]]; then
				if [[ $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $10}' | awk -F 'T' '{print $1}' | ${DATECMD} -f - +%s) -lt $(${DATECMD} --date "${DAYS} days ago" +%s) ]]; then
					echo -e "${RED}User $user has an access key older than ${DAYS} days.${NC}"
				else
					echo -e "${GREEN}User $user has valid keys yet${NC}"
				fi
			elif [[ $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $9}') == "false" && $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $14}') == "false" ]]; then
				echo "User $user has no active access keys"
			else
				echo "User $user is strange #######???"
			fi
		done
}

function listPassword {
	for user in ${onlyUSERS}; do
		if [[ $(echo "${REPORT}" | grep "$user," | awk -F ',' '{print $6}' | awk -F 'T' '{print $1}' | ${DATECMD} -f - +%s) -lt $(${DATECMD} --date "${DAYS} days ago" +%s) ]]; then
			echo -e "${RED}User $user has passowrd older than ${DAYS} days.${NC}"
		else
			echo -e "${GREEN}User $user has valid password yet${NC}"
		fi
	done
}

#set correct gdate 
DATECMD="gdate" #for MAC
# DATECMD="date" #for Linux
#Set the colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

#Presteps
aws iam generate-credential-report > /dev/null
echo "Generating credential report..."
REPORT=$(aws iam get-credential-report | jq ".Content" -r | base64 --decode)
USERS=$(aws iam list-users --output text | cut -f7)
onlyUSERS=$(aws iam list-users --output text | cut -f7 | grep -iv automation | grep -iv command)
NEW_PASSWORD=$(pwgen -cnsy 18 1)
DAYS="90"

while :
do
  echo ""
  echo -e "${GREEN}Please select an option:${NC}"
  echo "1. Delete IAM user access keys with an age greater than ${DAYS} days"
  echo "2. Rotate passwords for IAM users"
  echo "3. List IAM users with access keys older than ${DAYS} days"
  echo "4. List IAM users with passwords older than ${DAYS} days"
  echo "5. Exit"
  read response

  #Delete IAM user access keys with an age greater than ${DAYS} days
  if [[ $response == "1" ]]; then
	  deleteKeys
  fi

  #Rotate passwords for IAM users
  if [[ $response == "2" ]]; then
	  rotatePassword
  fi

  #List IAM users with access keys older than ${DAYS} days
  if [[ $response == "3" ]]; then
	  listKeys
  fi

  #List IAM users with passwords older than ${DAYS} days
  if [[ $response == "4" ]]; then
	  listPassword
  fi

  #Exit
  if [[ $response == "5" ]]; then
    echo -e "${RED}Exiting...${NC}"
    break
  fi
done
