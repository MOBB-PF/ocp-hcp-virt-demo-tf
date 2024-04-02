#!/bin/bash
date=`date`
echo "#########################################"
echo "Script start $date"
echo "#########################################"

# login rosa 
rosa login -t $RHCS_TOKEN
# Check if cluster is ready
i=0
while [ true ]
do
  result=`rosa list clusters|grep -i $cluster|awk '{print $3}'`
  if [[ $result == "ready" ]]
    then
      echo "result = Cluster is $result"
      break
  fi
  ((i++))
  if [[ "$i" == '100' ]]
    then
      echo "Number $i!"
      exit 1
  fi
  echo "cluster not ready sleeping 30"
  sleep 30
done
# Create admin user
login=`rosa create admin --cluster=$cluster| grep -i oc`
if [ $? -ne 0 ]
then
  echo "Failed to create Rosa cluster-admin user"
  exit 1
else
  echo "Successfully created rosa cluster-admin user."
fi
pw=`echo $login | awk '{print $7}'`
url=`echo $login | awk '{print $3}'`
domain=`echo $login | awk -F\. '{print $2"."$3"."$4"."$5"."$6}'|awk -F\: '{print $1}'`
echo $login
# Update secret value
aws secretsmanager put-secret-value --secret-id $secret --secret-string "{\"user\":\"cluster-admin\",\"password\":\"$pw\",\"url\":\"$url\"}"
if [ $? -ne 0 ]
then
  echo "Failed to updated AWS secret with cluster admin password."
  exit 1
else
  echo "Updated Rosa cluster-admin password to aws secret"
fi
# log into cluster
i=0
while [ true ]
do
  result=`$login --insecure-skip-tls-verify`
  if [ $? -eq 0 ]
    then
      break
  fi
  ((i++))
  if [[ "$i" == '100' ]]
    then
      echo "Number $i!"
      exit 1
  fi
  echo "cluster login not ready sleeping 30"
  sleep 30
done

sleep 120
oc project openshift-operators
# helm repo add --username foster-rh --password $helm_token helm_repo $helm_repo 
# helm repo update
helm install operators ../helm/$helm_chart --version $helm_chart_version --insecure-skip-tls-verify --set rosaDomain=$domain|grep -i err
if [ $? -eq 0 ]
  then
    echo "Helm failed to install initial helm operators successfully attemp $i - exiting"
    exit 1
fi
echo "Helm successfully installed seed chart."
date=`date`
rosa describe cluster -c $cluster
echo "#########################################"
echo "END $date"
echo "#########################################"


