#!/bin/bash
cd /fivem-server/
mv player.log playerlogs/player_$(date +"%Y-%m-%d_%H-%M-%S").log
bash server/run.sh +exec server.cfg |& tee -a logs/server_$(date +"%Y-%m-%d_%H-%M-%S").log
