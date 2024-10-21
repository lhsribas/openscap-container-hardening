#!/bin/bash
# Validate if NAME, IMAGE, and IMAGE_TAG are not empty
if [ -z "$1" ]; then
  echo "Error: NAME is not provided."
  exit 1
fi

if [ -z "$2" ]; then
  echo "Error: IMAGE is not provided."
  exit 1
fi

if [ -z "$3" ]; then
  echo "Error: IMAGE_TAG is not provided."
  exit 1
fi

# Assign arguments to variables
NAME=$1
IMAGE=$2
IMAGE_TAG=$3
DOCKER_HOST="REGISTRY.EXAMPLE.VHI"

# Print a success message
echo "All variables are provided."
echo "NAME: $NAME"
echo "IMAGE: $IMAGE"
echo "IMAGE_TAG: $IMAGE_TAG"

# Messaging Starting
echo "Hardening container base image..."

# Scanning and Fixing the Container Base Image
docker run -it --name $NAME $IMAGE:$IMAGE_TAG /bin/bash -c 'oscap xccdf eval --remediate --profile xccdf_redhat_profile_standard_ubi9  /usr/share/xml/scap/ssg/content/ubi9-xccdf.xml'

# Exporting the results
RESULTS=$?

echo $RESULTS

# Check if RESULTS is different from 0
if [ "$RESULTS" -ne 2 ]; then
    echo "#1 Failed, output: $RESULTS"
else
    echo "Success"
    echo "Commiting new contianer base image..."
    
    # Commit the container changes
    docker commit $NAME "harden"-$NAME
    
    # Exporting the results
    RESULTS=$?

    # Check if RESULTS is different from 0
    if [ "$RESULTS" -ne 0 ]; then
        echo "#2 Failed, output: $RESULTS"
    else
        echo "Success"
        echo "Saving new container base image..."

        # Saving the container base image
        docker save -o "harden"-$NAME.tar "harden"-$NAME
        
        # Exporting the results
        RESULTS=$?

        # Check if RESULTS is different from 0
        if [ "$RESULTS" -ne 0 ]; then
            echo "#3 Failed, output: $RESULTS"
        else
            echo "Tagging new container base image..."

            docker tag "harden"-$NAME:latest $DOCKER_HOST"/harden"-$NAME:$IMAGE_TAG
            
            # Exporting the results
            RESULTS=$?

            # Check if RESULTS is different from 0
            if [ "$RESULTS" -ne 0 ]; then
                echo "#4 Failed, output: $RESULTS"
            else
               # echo "Pushing new container base image..."

                #docker push $DOCKER_HOST"/harden"-$NAME:$IMAGE_TAG
                echo "Removing old container base image..."

                docker rm $NAME --force

                # Exporting the results
                RESULTS=$?
            fi
        fi
    fi
fi
