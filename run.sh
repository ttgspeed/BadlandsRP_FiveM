#!/bin/bash
fx_root=`dirname "$(readlink -f "$0")"`
echo "Removing Cache"
rm -rf $fx_root/cache
MONO_PATH=$fx_root/mono/ mono $fx_root/CitizenMP.Server.exe $* |& tee -a server.log
