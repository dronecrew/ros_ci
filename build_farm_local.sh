#!/bin/bash
BUILD_DIR=$(pwd)
JOB_PATH=/tmp/prerelease_job
CONFIG_URL=https://raw.githubusercontent.com/ros-infrastructure/ros_buildfarm_config/production/index.yaml
# either install the latest released version of ros_buildfarm
pip install ros_buildfarm
# or checkout a specific branch
#git clone -b master https://github.com/ros-infrastructure/ros_buildfarm /tmp/ros_buildfarm
#pip install /tmp/ros_buildfarm
# checkout catkin for catkin_test_results script
git clone https://github.com/ros/catkin /tmp/catkin
# run pre_release job for a ROS repository with the same name as this repo
export REPOSITORY_NAME=`basename $BUILD_DIR`
echo REPOSITORY_NAME: $REPOSITORY_NAME
# use the code already checked out by Travis
mkdir -p $JOB_PATH/catkin_workspace/src
cp -R $BUILD_DIR $JOB_PATH/catkin_workspace/src/
# generate the script to run a prerelease job for that target and repo
cd $JOB_PATH
generate_prerelease_script.py $CONFIG_URL kinetic default ubuntu xenial amd64 --output-dir . --custom-repo ros_ci:git:https://github.com/dronecrew/ros_ci.git:master
cat prerelease.sh
# run the actual job which involves Docker
sh prerelease.sh -y
