#!/bin/bash

# save the script directory
# from https://stackoverflow.com/a/4774063/223967
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

echo "Removing Cache"
#rm -rf $SCRIPTPATH/../cache
find $SCRIPTPATH/../cache/files ! -regex  '.*\(sessionmanager\|files\)$' -print0 | xargs -0 rm -rf

# run proot
exec $SCRIPTPATH/proot -b $PWD -R $SCRIPTPATH/alpine/ /opt/cfx-server/FXServer +set citizen_dir /opt/cfx-server/citizen/ $* |& tee -a server.log
