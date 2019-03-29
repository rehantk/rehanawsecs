#!/bin/bash

REGION=ap-south-1b
SERVICE_NAME=rehannoodle-app-service
CLUSTER=rehannoodle-cluster
IMAGE_VERSION="v_"${BUILD_NUMBER}
TASK_FAMILY="rehannoodle-app"

# Create a new task definition for this build

sed -e "s;%BUILD_NUMBER%;${BUILD_NUMBER};g" ../rehannoodle-app.json >rehannoodle-app-v_${BUILD_NUMBER}.json

aws ecs register-task-definition --family rehannoodle-app --cli-input-json file://rehannoodle-app-v_${BUILD_NUMBER}.json

# Update the service with the new task definition and desired count
REVISION=`aws ecs describe-task-definition --task-definition rehannoodle-app | egrep "revision" | tr "/" " " | awk '{print $2}' | sed 's/"$//'`
SERVICES=`aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER} --region ${REGION} | jq .failures[]`


#Create or update service
if [ "$SERVICES" == "" ]; then
  echo "entered existing service"
  DESIRED_COUNT=`aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER} --region ${REGION} | jq .services[].desiredCount`
  if [ ${DESIRED_COUNT} = "0" ]; then
    DESIRED_COUNT="1"
  fi
  aws ecs update-service --cluster ${CLUSTER} --region ${REGION} --service ${SERVICE_NAME} --task-definition ${TASK_FAMILY}:${REVISION} --desired-count ${DESIRED_COUNT} --deployment-configuration maximumPercent=100,minimumHealthyPercent=0
else
  echo "entered new service"
  aws ecs create-service --service-name ${SERVICE_NAME} --desired-count 1 --task-definition ${TASK_FAMILY} --cluster ${CLUSTER} --region ${REGION}
fi
