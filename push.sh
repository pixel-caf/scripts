#!/usr/bin/env bash

# Set the branch you want to push to
export BRANCH="n-mr1"

# Assumes source is in users home in a directory called "caf"
export SOURCE_DIR="${HOME}/caf"
export DIR=$PWD

cd ${SOURCE_DIR}

for repos in $(grep 'remote="android-caf"' ${SOURCE_DIR}/manifest/default.xml  | awk '{print $2}' | cut -d'"' -f2); do
echo -e "Pushing $repos to $BRANCH";
cd $repos;
git push -u -f android-caf HEAD:$BRANCH;
cd ${SOURCE_DIR}
done

cd ${DIR}
