#!/bin/bash
## _______________________________________________________________________________##
##| Name: repomigration.sh                                                        |#
##| Date: April 2022                                                              |# 
##| Author: Benjamin TOSELLO                                                      |#
##| Description: Program for migrate git repos to GH                              |# 
##|_______________________________________________________________________________|#
# 
#  Notes: This script should run in a EMPTY DIR    
#  _____________________________________________
#
#  Mandatory before run: 
#     - Needs "./repos.txt" file set with the list of repositories (ex. "my-repo.git" ...).
#     - Complete the Parameters section below in the code
#



# --------------------------------------------------------------------------
#           FUNCTION CLONE REPOS
# --------------------------------------------------------------------------
clone_repos ()
{
    echo $line >> $LOG
    echo "Clone Repo Function" >> $LOG
    echo $line >> $LOG
    for repo in `cat $FILE`
    do
        echo "Cloning" $repo
        if echo "$repo" | grep -q ".git"; then
            command="git clone --mirror git@$oldgit:$oldorg/$repo"
        else
            command="hg"
        fi
        # Run the command
        $command
        STATUS=$?
        if [ $STATUS = 0 ]; then
            echo "Success clone for $repo" 
            echo "Success clone for $repo" >> $LOG
            newname=`echo "$repo" | awk -F.git '(NF!=0) {print $1}'`
            
            # replace _ for -
            new=${newname//_/-}

            echo "$repo@$prefix$newname" >> $NEW_REPOS
        else
            echo "Error clone in repo $repo"
            echo "Error clone in repo $repo" >> $LOG
        fi
    done
    
}

# --------------------------------------------------------------------------
#           FUNCTION CREATE REPOS
# --------------------------------------------------------------------------
create_repos ()
{
    echo $line >> $LOG
    echo "Create Repo Function" >> $LOG
    echo $line >> $LOG
    for repo in `cat $NEW_REPOS`
    do
        newrepo=`echo "$repo" | awk -F@ '(NF!=0) {print $2}'`
        if [[ $newrepo == "" ]]; then
            continue
        fi
        echo "Creating repo " $newrepo
        curl \
            -X POST \
            -H "Accept: application/vnd.github.v3+json" \
            -H "Authorization: token $ghtoken" \
            https://api.github.com/orgs/alula-net/repos \
            -d '{"name":"'"$newrepo"'","description":"'"$repodescr"'","private":true}'
        STATUS=$?
        if [ $STATUS = 0 ]; then
            echo "Success creation for $newrepo" 
            echo "Success creation for $newrepo" >> $LOG
        else
            echo "Error in repo $newrepo"
            echo "Error in repo $newrepo" >> $LOG
        fi
    done

}

# --------------------------------------------------------------------------
#           FUNCTION MIGRATE DATA
# --------------------------------------------------------------------------
migrate_repos ()
{
    echo $line >> $LOG
    echo "Migrate Repo Function" >> $LOG
    echo $line >> $LOG
    for repo in `cat $NEW_REPOS`
    do
        newrepo=`echo "$repo" | awk -F@ '(NF!=0) {print $2}'`
        oldrepo=`echo "$repo" | awk -F@ '(NF!=0) {print $1}'`
        if [[ $newrepo == "" ]]; then
            continue
        fi 
        echo "Uploading the $newrepo repo" 
        cd $oldrepo  
        # Set the new remote
        git remote set-url --push origin git@github.com:$neworg/$newrepo.git
        # Set the push location to your mirror
        git push --mirror
        STATUS=$?
        # go back dir...
        cd .. 

        if [ $STATUS = 0 ]; then
            echo "Success migration for $newrepo" >> $LOG
            echo "Success migration for $newrepo"
        else
            echo "Error in migration $newrepo"
            echo "Error in migration $newrepo" >> $LOG
        fi
    done

}

# --------------------------------------------------------------------------
#           FUNCTION REPO PERMISSIONS 
# --------------------------------------------------------------------------
repo_permissions ()
{
    echo $line >> $LOG
    echo "Permissions Function" >> $LOG
    echo $line >> $LOG
    for repo in `cat $NEW_REPOS`
    do
        newrepo=`echo "$repo" | awk -F@ '(NF!=0) {print $2}'`
        if [[ $newrepo == "" ]]; then
            continue
        fi
        echo "****************************" >> $LOG
        echo " Repo $newrepo " >> $LOG
        echo "****************************" >> $LOG
        echo "Creating Protections Rules on Branch for Repo $newrepo (master)"
        echo "Creating Protections Rules on Branch for Repo $newrepo (master)" >> $LOG
        run=$(curl \
            -X PUT \
            -s \
            -H "Accept: application/vnd.github.v3+json" \
            -H "Authorization: token $ghtoken" \
            https://api.github.com/repos/$neworg/$newrepo/branches/master/protection \
            -d '{"required_status_checks": null,"enforce_admins": true,"required_pull_request_reviews" : {"dismissal_restrictions": {},"dismiss_stale_reviews": false,"require_code_owner_reviews": false,"required_approving_review_count": 1},"restrictions":null}')
        echo $run >> $LOG

        echo "Setting Default Branch for Repo $newrepo (master)"
        echo "Setting Default Branch for Repo $newrepo (master)" >> $LOG
        run=$(curl \
            -X PATCH \
            -s \
            -H "Accept: application/vnd.github.v3+json" \
            -H "Authorization: token $ghtoken" \
            https://api.github.com/repos/$neworg/$newrepo \
            -d '{"default_branch": "master"}')
        echo $run >> $LOG

        echo "Add Team for Repo $newrepo "
        echo "Add Team for Repo $newrepo " >> $LOG
        run=$(curl \
            -X PUT \
            -s \
            -H "Accept: application/vnd.github.v3+json" \
            -H "Authorization: token $ghtoken" \
            https://api.github.com/orgs/$neworg/teams/$ghteam/repos/alula-net/$newrepo \
            -d '{"permission":"mantain"}')
        echo $run >> $LOG

    done

}



# --------------------------------------------------------------------------
#           FUNCTION REPO LIST 
# --------------------------------------------------------------------------
repo_list ()
{   
    echo $line >> $LOG
    echo "Repo List" >> $LOG
    echo $line >> $LOG
    
    gh repo list alula-net -L 400 --no-archived >> $REPO_LIST

    echo "File saved in ./repolist.csv"
    echo "File saved in ./repolist.csv" >> $LOG
}

#****************
# Files
#****************
FILE="./repos.txt"
NEW_REPOS="./newrepos.txt"
LOG="./reposlog.txt"
REPO_LIST="./repolist.csv"

#****************
# Parameters
#****************
oldorg="old-org-in-previous-repo"
neworg="my-new-org-in-gh"
prefix=""
oldgit="bitbucket.org"
repodescr="Your Repo description"
ghteam="gh-team-to-be-added"
ghtoken="ghp_your-token"
line="----------------------------------------------------"

# Delete files if exists
if test -e $NEW_REPOS
then
  rm $NEW_REPOS
fi
if test -e $LOG
then
  rm $LOG
fi
if test -e $REPO_LIST
then
  rm $REPO_LIST
fi

DAY=`date +%Y%m%d`
HOUR=`date +%H%M`
numdir=`ls -l | grep -c ^d`

clear
echo "#--------------------------------------------------#"
echo "#   Program for migrate git repos to GH            #"
echo "#--------------------------------------------------#"
echo ""
echo "#--------------------------------------------------#"
echo "#   This script should be run in a EMPTY           #"
echo "#   directory without folders                      #"
echo "#--------------------------------------------------#"
echo "Do you confirm the RUN? (y/n)"
printf "\n=> " 
read stop
if [ "$stop" != "y" ]
then
  exit
fi

if [[ $numdir != 0 ]]; then
    echo $line
    echo "There are some folders in this DIR... Please use a directory without folders."
    echo $line
    exit
fi 


echo "#--------------------------------------------------#" >> $LOG 
echo "#   Program for migrate git repos to GH            #" >> $LOG 
echo "#--------------------------------------------------#" >> $LOG 
echo "" >> $LOG 
echo "Init: "$DAY "Hour:" $HOUR >> $LOG 
echo $line >> $LOG
#Script Steps
echo "Clone repos init"
clone_repos
echo "Creating repos init"
create_repos
echo "Migrate repos init"
migrate_repos
echo "Permissions"
repo_permissions
#---------------
# Optional Step
#---------------
#echo "Repo list"
#repo_list

echo $line >> $LOG
DAY=`date +%Y%m%d`
HOUR=`date +%H%M`
echo "Finish: "$DAY "Hour:" $HOUR >> $LOG 
echo $line >> $LOG
