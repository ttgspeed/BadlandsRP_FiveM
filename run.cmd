set hr=%time:~0,2%
if "%hr:~0,1%" equ " " set hr=0%hr:~1,1%
timeout /t 5
move C:\fivem-server\player.log C:\fivem-server\logs_player\player_%date:~-4,4%-%date:~-10,2%-%date:~-7,2%_%hr%-%time:~3,2%-%time:~6,2%.log
C:\fivem-server\server\run.cmd +exec server.cfg > C:\fivem-server\logs_server\server_%date:~-4,4%-%date:~-10,2%-%date:~-7,2%_%hr%-%time:~3,2%-%time:~6,2%.log