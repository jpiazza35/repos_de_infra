#!/bin/bash
#--------------------------------------------------#
#   Program pull and push ECR images repos         #
#   Author: Benjamin TOSELLO - July 2022           #
#--------------------------------------------------#



# --------------------------------------------------------------------------
#           FUNCTION PULL IMAGES
# --------------------------------------------------------------------------
pull_images ()
{
    # Export FROM profile. awsproffrom varaible is set by the user when we run the script 
    export AWS_PROFILE=$awsproffrom
    # This comman get the current aws account
    awsaccount=`aws sts get-caller-identity --query 'Account' --output text`
    # Get the aws region from the aws configure set in the profile
    awsregion=`aws configure get region`
    echo "Current profile: " $AWS_PROFILE
    echo "Current profile: " $AWS_PROFILE >> $LOG
        
    echo $line >> $LOG
    echo "docker login"
    echo "docker login" >> $LOG
    # Do docker loging to the old account to could get the images to be downloaded
    aws ecr get-login-password --region $awsregion | docker login --username AWS --password-stdin $awsaccount.dkr.ecr.$awsregion.amazonaws.com
    STATUS=$?
    if [ $STATUS = 0 ]; then
        echo "Success docker login => aws ecr get-login-password --region $awsregion | docker login --username AWS --password-stdin $awsaccount.dkr.ecr.$awsregion.amazonaws.com" 
        echo "Success docker login => aws ecr get-login-password --region $awsregion | docker login --username AWS --password-stdin $awsaccount.dkr.ecr.$awsregion.amazonaws.com"  >> $LOG
    else
        echo "Error docker login => aws ecr get-login-password --region $awsregion | docker login --username AWS --password-stdin $awsaccount.dkr.ecr.$awsregion.amazonaws.com" 
        echo "Error docker login => aws ecr get-login-password --region $awsregion | docker login --username AWS --password-stdin $awsaccount.dkr.ecr.$awsregion.amazonaws.com"  >> $LOG
    fi
    echo $line >> $LOG

    echo "Pull Images Function" 
    echo "Pull Images Function" >> $LOG
    for forrepo in `cat $FILE`
    do
        repo=`echo "$forrepo" | awk -F@ '(NF!=0) {print $1}'`
        newnamerepo=`echo "$forrepo" | awk -F@ '(NF!=0) {print $2}'`
        echo $line >> $LOG
        echo "Run aws ecr describe-images for: " $repo
        echo "Run aws ecr describe-images for: " $repo >> $LOG
        # Run the describe command and bring the 10 last images
        aws ecr describe-images --repository-name $repo --query 'reverse(sort_by(imageDetails,& imagePushedAt))[:10]' --output text | awk '{print $2}' > $NEW_FILE
        STATUS=$?
        if [ $STATUS = 0 ]; then
            echo "Success describe for $repo" 
            echo "Success describe for $repo" >> $LOG
        else
            echo "Error describe in $repo"
            echo "Error describe in $repo" >> $LOG
        fi
        echo $line >> $LOG

        for image in `tac $NEW_FILE`
        do
            if [[ "$image" == *"sha256"* ]]; then
                echo "==> Image with no tags: $image"
                echo "==> Image with no tags: $image" >> $LOG
            else
                echo "==> docker pull $awsaccount.dkr.ecr.$awsregion.amazonaws.com/$repo:$image"
                echo "==> docker pull $awsaccount.dkr.ecr.$awsregion.amazonaws.com/$repo:$image" >> $LOG
                # Run the command of docker pull with the correct varaibles
                docker pull $awsaccount.dkr.ecr.$awsregion.amazonaws.com/$repo:$image
                STATUS=$?
                if [ $STATUS = 0 ]; then
                    echo "Success pulling image for $repo and tag $image" 
                    echo "Success pulling image for $repo and tag $image" >> $LOG
                    # Prepare commands with new repo name
                    echo "docker push ##NEWACC.dkr.ecr.##NEWREG.amazonaws.com/$newnamerepo:$image" >> $PULL_IMAGES
                    echo "docker tag $awsaccount.dkr.ecr.$awsregion.amazonaws.com/$repo:$image ##NEWACC.dkr.ecr.##NEWREG.amazonaws.com/$newnamerepo:$image" >> $TAG_IMAGES
                else
                    echo "Error pulling image in $repo and tag $image"
                    echo "Error pulling image in $repo and tag $image" >> $LOG
                fi
                # Prepare commands with new repo name
                echo "##NEWACC.dkr.ecr.##NEWREG.amazonaws.com/$newnamerepo" >> $MAIN_REPO
                echo "$awsaccount.dkr.ecr.$awsregion.amazonaws.com/$repo" >> $MAIN_REPO
            fi
        done

    done
}


# --------------------------------------------------------------------------
#           FUNCTION PUSH IMAGES
# --------------------------------------------------------------------------
push_images ()
{
    # Export TO profile. awsprofto varaible is set by the user when we run the script
    export AWS_PROFILE=$awsprofto
    # This comman get the current aws account
    awsnewacc=`aws sts get-caller-identity --query 'Account' --output text`
    # Get the aws region from the aws configure set in the profile
    awsnewreg=`aws configure get region`

    echo $line >> $LOG
    echo "Current profile: " $AWS_PROFILE
    echo "Current profile: " $AWS_PROFILE >> $LOG

    echo $line >> $LOG
    echo "docker login"
    echo "docker login" >> $LOG
    # Do docker loging to the new account to could get the images to be downloaded
    aws ecr get-login-password --region $awsnewreg | docker login --username AWS --password-stdin $awsnewacc.dkr.ecr.$awsnewreg.amazonaws.com
    STATUS=$?
    if [ $STATUS = 0 ]; then
        echo "Success docker login => aws ecr get-login-password --region $awsnewreg | docker login --username AWS --password-stdin $awsnewacc.dkr.ecr.$awsnewreg.amazonaws.com" 
        echo "Success docker login => aws ecr get-login-password --region $awsnewreg | docker login --username AWS --password-stdin $awsnewacc.dkr.ecr.$awsnewreg.amazonaws.com"  >> $LOG
    else
        echo "Error docker login => aws ecr get-login-password --region $awsnewreg | docker login --username AWS --password-stdin $awsnewacc.dkr.ecr.$awsnewreg.amazonaws.com" 
        echo "Error docker login => aws ecr get-login-password --region $awsnewreg | docker login --username AWS --password-stdin $awsnewacc.dkr.ecr.$awsnewreg.amazonaws.com"  >> $LOG
    fi

    # Re-tagging
    echo $line >> $LOG
    echo "Re-tagging..."
    echo "Re-tagging..." >> $LOG
    echo $line >> $LOG
    sed 's/##NEWACC/'$awsnewacc'/g;s/##NEWREG/'$awsnewreg'/g;/^ *$/d' $TAG_IMAGES > $TEMP
    # Read file Re-tagging
    while IFS= read -r currentline
    do
        echo "==> $currentline"
        # Run the Re-tagging
        $currentline
        STATUS=$?
        if [ $STATUS = 0 ]; then
            echo "Success re-tagging image: $currentline" 
            echo "Success re-tagging image: $currentline"  >> $LOG
        else
            echo "Error re-tagging image: $currentline" 
            echo "Error re-tagging image: $currentline"  >> $LOG
        fi
    done < $TEMP

    # Docker push
    echo $line >> $LOG
    echo "Push Images Function" 
    echo "Push Images Function" >> $LOG
    echo $line >> $LOG
    sed 's/##NEWACC/'$awsnewacc'/g;s/##NEWREG/'$awsnewreg'/g;/^ *$/d' $PULL_IMAGES > $TEMP2
    while IFS= read -r currentline
    do
        echo "==> $currentline" 
        # Run the command of docker push with the correct varaibles
        $currentline
        if [ $STATUS = 0 ]; then
            echo "Success pushing image: $currentline" 
            echo "Success pushing image: $currentline"  >> $LOG
        else
            echo "Error pushing image: $currentline" 
            echo "Error pushing image: $currentline"  >> $LOG
        fi
    done < $TEMP2

    # Prepare delete
    sed 's/##NEWACC/'$awsnewacc'/g;s/##NEWREG/'$awsnewreg'/g' $MAIN_REPO > $TEMP
    cat $TEMP | sort | uniq > $MAIN_REPO
}


# --------------------------------------------------------------------------
#           FUNCTION DELETE IMAGES
# --------------------------------------------------------------------------
delete_images ()
{
    while true; do
    read -p "Do you confirm DELETING all the images migrated? (y/n)" yn
    case $yn in
        [Yy]* ) 
            # Deleting images
            echo $line >> $LOG
            echo "Deleting images..."
            echo "Deleting images..." >> $LOG
            echo $line >> $LOG
            while IFS= read -r currentline
            do
                if [ $currentline != "" ]; then
                    echo "==> DELETING $currentline" 
                    docker rmi -f $(docker images -q $currentline) 
                    if [ $STATUS = 0 ]; then
                        echo "Success deleting image: $currentline" 
                        echo "Success deleting image: $currentline"  >> $LOG
                    else
                        echo "Error deleting image: $currentline" 
                        echo "Error deleting image: $currentline"  >> $LOG
                    fi
                fi
            done < $MAIN_REPO;
            break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
    done   
}

# --------------------------------------------------------------------------
#           FUNCTION CLEAN UP
# --------------------------------------------------------------------------
clean_up ()
{
    rm $NEW_FILE
    rm $MAIN_REPO
    rm $SUB_IMAGES
    rm $PULL_IMAGES
    rm $TAG_IMAGES
    rm $TEMP
    rm $TEMP2
    rm $NO_TAG
}


# Mandatory file
# You must create this file with the list of ECR repos where the script will pull and push the images.
# You can have differents names of repo (from / to)
# eg:
# oldname/old-ecr-repo@newname/new-ecr-repo
FILE="./repos.txt"  

# Files
NEW_FILE="./newfile.txt"
LOG="./execution-log.txt"
MAIN_REPO="./main_repo.txt"
SUB_IMAGES="./sub_images.txt"
PULL_IMAGES="./pull_images.txt"
TAG_IMAGES="./tag_images.txt"
TEMP="./temp.txt"
TEMP2="./temp2.txt"
NO_TAG="./notag.txt"

# Variables
line="----------------------------------------------------"

# Delete file if exists
if test -e $NEW_FILE
then
  rm $NEW_FILE
fi
if test -e $LOG
then
  rm $LOG
fi
if test -e $MAIN_REPO
then
  rm $MAIN_REPO
fi
if test -e $SUB_IMAGES
then
  rm $SUB_IMAGES
fi
if test -e $TEMP
then
  rm $TEMP
fi
if test -e $TEMP2
then
  rm $TEMP2
fi
if test -e $PULL_IMAGES
then
  rm $PULL_IMAGES
fi
if test -e $TAG_IMAGES
then
  rm $TAG_IMAGES
fi

DAY=`date +%Y%m%d`
HOUR=`date +%H%M`
numdir=`ls -l | grep -c ^d`

clear
echo "#--------------------------------------------------#"
echo "#   Program for pull / push ECR images             #"
echo "#--------------------------------------------------#"
printf "\n Note: \n You should have defined 2 fresh aws profiles in your machine ..."
printf "\n path =>  ~/.aws/credentials"
printf "\n\n eg:"
printf "\n\n [alula-test]"
printf "\n aws_access_key_id=A..."
printf "\n aws_secret_access_key=KQ...."
printf "\n aws_session_token=IQ..."
printf "\n region=us-east-1"

if test -e $FILE
then
    printf "\n\n$line"
    printf "\nThe following ECR repos will be proceced:\n\n"
    cat $FILE
    printf "\n$line"
else
    printf "\n\n$line"
    printf "\nERROR: You should create a file in this directory"
    printf "\ncalled 'repos.txt' and list the 'old@new' ECR repos to be created"
    printf "\n$line\n\n"
    exit
fi

printf "\n\nEnter the AWS FROM profile..."
printf "\n=> " 
# Enter the aws profile where you are going to do the copy from. This must be set previously in your ~/.aws/credentials file.
read awsproffrom
printf "\nEnter the AWS TO profile..."
printf "\n=> " 
# Enter the aws profile where you are going to do the copy to. This must be set previously in your ~/.aws/credentials file.
read awsprofto
printf "\n$line"
printf "\nYou have entered..."
printf "\n  AWS FROM profile $awsproffrom"
printf "\n  AWS TO profile $awsprofto "
printf "\n$line"
printf "\nDo you confirm the RUN? (y/n)"
printf "\n=> " 
read stop
if [ "$stop" != "y" ]
then
  exit
fi


echo "#--------------------------------------------------#" >> $LOG 
echo "#   Program for pull / push ECR images             #" >> $LOG 
echo "#--------------------------------------------------#" >> $LOG 
echo "" >> $LOG 
echo "Init: "$DAY "Hour:" $HOUR >> $LOG 
echo $line >> $LOG
#Script Steps
echo "Pulling images init"
# It will run the docker pull from the ecr repos set it in the repos.txt file.
pull_images
echo "Pushing images init"
# It will run the docker push for the ecr images downloaded to the repos set in the repos.txt file.
push_images
echo "Deleting images init"
# You can choose to delete or not the images that you had dowloaded.
delete_images
echo "Clean up init"
# After all have finished I delete the files created, except the Logs file.
clean_up

echo $line >> $LOG
DAY=`date +%Y%m%d`
HOUR=`date +%H%M`
echo "Finish: "$DAY "Hour:" $HOUR >> $LOG 
echo $line >> $LOG
