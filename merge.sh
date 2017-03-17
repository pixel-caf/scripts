#!/usr/bin/env bash

#COLORS -
red=$'\e[1;31m'
grn=$'\e[1;32m'
blu=$'\e[1;34m'
end=$'\e[0m'


# Assumes source is in users home in a directory called "caf"
export CAFPATH="${HOME}/caf"

# Set the tag you want to merge
export TAG="LA.UM.5.6.r1-03800-89xx.0"

# Set the branch you want to merge it into
export BRANCH="n-mr1"

do_not_merge="
vendor/aosp 
manifest  
external/bash 
device/qcom/sepolicy 
packages/apps/SnapdragonCamera"

cd ${CAFPATH}

for filess in failed success
do
rm $filess 2> /dev/null
touch $filess
done
# CAF manifest is setup with path first, then repo name, so the path attribute is after 2 spaces, and the name within "" in it
for repos in $(grep 'remote="android-caf"' ${CAFPATH}/.repo/manifests/default.xml  | awk '{print $2}' | cut -d '"' -f2)
do
echo -e ""
if [[ "${do_not_merge}" =~ "${repos}" ]];
then
echo -e "${repos} is not to be merged";
else
echo "$blu Merging $repos $end"
echo -e ""
cd $repos;
git checkout -b $BRANCH
git remote add upstream git://codeaurora.org/platform/$repos
git fetch --tags upstream
git merge $TAG
if [ $? -ne 0 ];
then
echo "$repos" >> ${CAFPATH}/failed
echo "$red $repos failed :( $end"
else
echo "$repos" >> ${CAFPATH}/success
echo "$grn $repos succeeded $end"
fi
echo -e ""
cd ${CAFPATH};
fi
done

echo -e ""
echo -e "$red These repos failed $end"
cat ./failed
echo -e ""
echo -e "$grn These succeeded $end"
cat ./success


