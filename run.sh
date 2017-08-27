#!/bin/bash
cd /fivem-server/
bash server/run.sh +exec server.cfg |& tee -a server$(date +"%Y-%m-%d_%H-%M-%S").log
