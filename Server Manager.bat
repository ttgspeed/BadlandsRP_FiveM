@echo off

::MADE BY feR#8191::
::SEE THE READ ME FOR HELP::

::FEITO POR feR#8191::
::VEJA O READ ME PARA AJUDA::

::###EXECUTE AS ADMIN###::
::###EXECUTE COMO ADMIN###::
::en-English | br-Português::

::CONFIGURATION::
set lang=en
REM Set the UI language
REM Define o idioma da UI
set sys_lang=en
REM Set the system language to avoid bugs. 
REM Define a linguagem do sistema operacional para evitar bugs
set isKeyBugHappening=false
REM See ReadMe for info (line 88)
REM Veja o LeiaMe para mais informações (linha 37)
set serverName=BadlandsRP
REM Set the server name
REM Define o nome do servidor
set serverIP=192.99.55.116
REM Set the server IP
REM Define o endereço IP do servidor
set stopTestServer=true
REM Stops the test server when the main server starts for the first time. You need to start the test server as administrator to this work.
REM Para o servidor de teste, se ativo, na primeira inicialização do servidor. Você precisa iniciar o teste server como admin para isso funcionar.
set stopTestServerAlways=true
REM Makes sure that the test server is offline every time the main server reboots
REM Toda vez que o servidor reiniciar, garante que o test server está desativado. 
set stopBrowser=false
REM Closes your selected browser, if open, when the server reboots
REM Toda vez que o servidor reiniciar, garante que o browser escolhido está fechado. 
set browserIm=chrome.exe
REM Define the browser image (.exe) name
REM Define a imagem (.exe) do navegador
set clearCache=false
REM Delete the server cache when the server starts for the first time
REM Apaga o cache do servidor ao abrir esse arquivo
set clearCacheAlways=false
REM Delete the cache every time the server reboots
REM Apaga o cache do servidor a cada reinício
set location=C:\Users\badlands\Documents\GitHub\BadlandsRP\server
REM Define the path to the server folder with a backslash at the end of the path. No quotation marks
REM Define o local da pasta do servidor com uma barra invertida no final.
set startServer_bat_location=C:\Users\badlands\Documents\GitHub\BadlandsRP\START_SERVER.bat
REM Define the location of the .bat (NOT the .cmd) to start the server. No quotation marks,
REM Define onde está o .bat (NÃO o .cmd) para iniciar o servidor. Sem aspas.
set backup=false
REM Backup the resources folder and the server.cgf at the server restart
REM Faz backup dos recursos e server.cfg quando o servidor reinicia
set backup_location="C:\Users\badlands\Documents\GitHub\BadlandsRP\backups\
REM Defines the folder in which the backups will be stored (DO NOT remove the quotation mark at the beggining of the path). Put a backslash at the end of the path.
REM Define a pasta em que serão salvos os backups (NÃO remova a aspa no início do local). Coloque uma barra invertida no final.
set backup_name=resources
REM Define the name of the backup folder (the backup saves the resources foldr and the server.cfg)
REM Define o nome da pasta do backup (o backup salva a pasta dos recursos e o server.cfg)
set title_main=BadlandsRP
REM Name of the cmd window of the main server 
REM Nome da janela do cmd do servidor principal 
set title_test=TEST SERVER
REM Name of the cmd window of the test server. 
REM Nome da janela do cmd do servidor de teste
set title_this=Server Manager
REM Name for this window
REM Nome para essa janela
set log_name=server
REM Set the log file name
REM Define o nome do arquivo de log
set log_type=log
REM Set the log file type (txt, docx, ...)
REM Define o tipo de arquivo do log (txt, docx, ...)
set log_path=C:\Users\badlands\Documents\GitHub\BadlandsRP\logs2
REM Define where the logs will be saved - DO NOT add quotation marks. The path can contain spaces.
REM Define onde os logs vão ser salvos -  NÃO adicione aspas. O local pode conter espaços.

::Restart Time::
REM See ReadME for AM/PM info (line 103)
set restart_1_hour=2
set restart_1_minutes=00

set restart_2_hour=8
set restart_2_minutes=00

set restart_3_hour=14
set restart_3_minutes=00

set restart_4_hour=20
set restart_4_minutes=00

::Messages::
if "%lang%"=="en" (
REM Delete "[%date% - %time%]" to supress the date and time output 
set msg_closingTestServer=[%date% - %time%] Closing test server...
set msg_TestServerClosed=[%date% - %time%] Test server already closed!
set msg_firstStart=[%date% - %time%] Starting the server for the first time...
set msg_restartingServer=[%date% - %time%] Rebooting server...
set msg_deletingCache=[%date% - %time%] Deleting server cache...
set msg_doingBackup=[%date% - %time%] Backup in progress...
set msg_backupDone=[%date% - %time%] Backup done!
set msg_startLog=[%date% - %time%] Starting %serverName% log...
set msg_closingBrowser=[%date% - %time%] Closing browser - %browserIm%
set msg_restart_done_part_1=[%date% - %time%] Restart #
set msg_restart_done_part_2= done! Going to restart #
set msg_testServerAlreadyClosed=INFO: The Test Server was already closed before the start of the main server!
set msg_cacheDeletedAtStart=INFO: The cache was deleted before the start of the server!
set msg_restartStatusFalse=[%date% - %time%] The restart done status of all restarts was settled to not done - false
set msg_cfgCopied=[%date% - %time%] The server.cfg was copied to
set msg_copyingCfg=[%date% - %time%] The server.cfg is being copied to
set msg_copyingFolder=[%date% - %time%] Copying the resources folder to
set msg_folderCopied=[%date% - %time%] The resources folder was copied to
set msg_restartStatusTrue_part_1=[%date% - %time%]	The reboot status of restart #
set msg_restartStatusTrue_part_2=was set to done - true
set msg_lastRestart_done=[%date% - %time%] Last restart of the day concluded!
)
if "%lang%"=="br" (
REM Apague "[%date% - %time%]" para ocultar a data e o horário - NÃO use acentos
set msg_closingTestServer=[%date% - %time%] Fechando servidor de teste...
set msg_TestServerClosed=[%date% - %time%] Servidor de teste ja esta fechado!
set msg_firstStart=[%date% - %time%] Iniciando o servidor pela primeira vez...
set msg_restartingServer=[%date% - %time%] Reiniciando o servidor...
set msg_deletingCache=[%date% - %time%] Apagando o cache do servidor...
set msg_doingBackup=[%date% - %time%] Fazendo backup...
set msg_backupDone=[%date% - %time%] Backup feito!
set msg_startLog=[%date% - %time%] Iniciando log do %serverName%...
set msg_closingBrowser=[%date% - %time%] Fechando browser - %browserIm%
set msg_restart_done_part_1=[%date% - %time%] Restart #
set msg_restart_done_part_2= concluido! Indo para o restart #
set msg_testServerAlreadyClosed=INFO: O servidor de teste ja estava fechado antes do inicio do servidor principal!
set msg_cacheDeletedAtStart=INFO: O cache foi deletado antes do inicio do servidor!
set msg_restartStatusFalse=[%date% - %time%] O status de restart de todos reinicios foram definidos como nao feito - false
set msg_cfgCopied=[%date% - %time%] O server.cfg foi copiado para
set msg_copyingCfg=[%date% - %time%] O server.cfg esta sendo copiado para
set msg_copyingFolder=[%date% - %time%] Copiando a pastas de recursos para
set msg_folderCopied=[%date% - %time%] A pasta de recursos foi copiada para
set msg_restartStatusTrue_part_1=[%date% - %time%] O status de reinicio do restart #
set msg_restartStatusTrue_part_2=foi definido como feito - true
set msg_lastRestart_done=[%date% - %time%] Ultimo restart do dia concluido!
)

::=====DO NOT EDIT BELOW THIS LINE=====::
::=====NÃO EDITE ABAIXO DESSA LINHA=====::

title %title_this%

::Bug Fixing::
if "%isKeyBugHappening%"=="true" (
	if "%sys_lang%"=="en" (
	set title_main=Administrator:  %title_main%
	set title_test=Administrator:  %title_test%
	)
	if "%sys_lang%"=="br" (
	set title_main=Administrador:  %title_main%
	set title_test=Administrador:  %title_test%
	)
) 

::Set Restart Time::
set restart_1_time=%restart_1_hour%h%restart_1_minutes%m
set restart_2_time=%restart_2_hour%h%restart_2_minutes%m
set restart_3_time=%restart_3_hour%h%restart_3_minutes%m
set restart_4_time=%restart_4_hour%h%restart_4_minutes%m

::Create Log::
set script_version=1.0
for /f "tokens=1-4 delims=/ " %%a in ('date /t') do (
	set log_day=%%a
	set log_month=%%a
)
for /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (
	set log_hours=%%a
	set log_minutes=%%b
)
set log_time=%log_hours%h%log_minutes%m
if "%lang%"=="en" (set log_date=%log_month%.%log_day%)
if "%lang%"=="br" (set log_date=%log_day%.%log_month%)
set log_time=%log_hours%h%log_minutes%m
set new_log_name=[%log_date% - %log_time%] %log_name%
set log_final="%log_path%\%new_log_name%.%log_type%"
if "%lang%"=="en" (
	REM In respect for other people work that was provided for free to you, please do not delete this
	echo Script Created by feR#8191 > %log_final%
	echo Check out my server! >> %log_final%
	echo City Life Roleplay - IP 144.217.32.38 >> %log_final%
	echo Discord.gg/s3HUypg  >> %log_final%
	echo Website: http://144.217.32.38 >> %log_final%
	echo Script Version: %script_version% >> %log_final%
)
if "%lang%"=="br" (
	REM Em respeito ao trabalho dos outros, que foi providenciaddo à você de graça, por favor não apague isso
	echo Script criado por feR#8191 > %log_final%
	echo Visite meu servidor! >> %log_final%
	echo City Life Roleplay - IP 144.217.32.38 >> %log_final%
	echo Discord.gg/s3HUypg  >> %log_final%
	echo Website: http://144.217.32.38 >> %log_final%
	echo Versao do Script: %script_version% >> %log_final%
)
echo.>> %log_final%
echo %msg_startLog% >> %log_final%
echo.>> %log_final%
echo ###Config### >> %log_final%
echo lang=%lang% >> %log_final%
echo sys_lang=%sys_lang%  >> %log_final%
echo serverName=%serverName% >> %log_final%
echo serverIP=%serverIP% >> %log_final%
echo stopTestServer=%stopTestServer% >> %log_final%
echo stopTestServerAlways=%stopTestServerAlways% >> %log_final%
echo stopBrowser=%stopBrowser% >> %log_final%
echo browserIm=%browserIm% >> %log_final%
echo clearCache=%clearCache% >> %log_final%
echo clearCacheAlways=%clearCacheAlways% >> %log_final%
echo location=%location% >> %log_final%
echo startServer_bat_location=%startServer_bat_location% >> %log_final%
echo backup=%backup% >> %log_final%
rem echo backup_location=%backup_location% >> %log_final% ##not working?
echo backup_name=%backup_name% >> %log_final%
echo title_main=%title_main% >> %log_final%
echo title_test=%title_test% >> %log_final%
echo title_this=%title_this% >> %log_final%
echo log_name=%log_name% >> %log_final%
echo log_type=%log_type% >> %log_final%
echo log_path=%log_path% >> %log_final%
echo.>> %log_final%
if "%lang%"=="en" (
	echo ###Retart Times### >> %log_final%
	echo First restart at %restart_1_time% >> %log_final%
	echo Second restart at %restart_2_time% >> %log_final%
	echo Third restart at %restart_3_time% >> %log_final%
	echo Fourth restart at %restart_4_time% >> %log_final%
)
if "%lang%"=="br" (
	echo ###Horarios de Restart### >> %log_final%
	echo Primeiro restart as %restart_1_time% >> %log_final%
	echo Segundo restart as %restart_2_time% >> %log_final%
	echo Terceiro restart as %restart_3_time% >> %log_final%
	echo Quarto restart as %restart_4_time% >> %log_final%
)
echo.>> %log_final%

::First Steps::
tasklist /FI "WINDOWTITLE eq %title_test%" 2>NUL | find /I /N "cmd.exe">NUL
if "%ERRORLEVEL%"=="0" (set isTestServerRunning=true) else (set isTestServerRunning=false)

tasklist /FI "IMAGENAME eq %browserIm%" 2>NUL | find /I /N "%browserIm%">NUL
if "%ERRORLEVEL%"=="0" (set isBrowserRunnig=true) else (set isBrowserRunnig=false)

if "%isTestServerRunning%"=="true" (
	if "%stopTestServer%"=="true" (
		echo %msg_closingTestServer%
		echo %msg_closingTestServer% >> %log_final%
		taskkill /F /FI "WINDOWTITLE eq %title_test%" /T >> %log_final%
	)
)
if "%isTestServerRunning%"=="false" (
	if "%stopTestServer%"=="true" (
		echo %msg_testServerAlreadyClosed%
		echo %msg_testServerAlreadyClosed% >> %log_final%
	) 
)
if "%clearCache%"=="true" (
	echo %msg_cacheDeletedAtStart%
	echo %msg_cacheDeletedAtStart% >> %log_final%
	rmdir %location%cache /s /q
)

::Start Server::
echo %msg_firstStart%
echo %msg_firstStart% >> %log_final%
:start
start %startServer_bat_location% 
set restart_1_done=false
set restart_2_done=false
set restart_3_done=false
set restart_4_done=false
echo %msg_restartStatusFalse%
echo %msg_restartStatusFalse% >> %log_final%

::Get Local Time::
:getTime
for /f "tokens=1-4 delims=/ " %%a in ('date /t') do (set local_day=%%a)
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set local_month=%%a)
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set local_year=%%b)
for /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set local_hours=%%a)
for /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set local_minutes=%%b)
set local_time=%local_hours%h%local_minutes%m
if "%lang%"=="en" (
	set local_date=%local_month%/%local_day%
)
if "%lang%"=="br" (
	set local_date=%local_day%/%local_month%
)
REM Needed for bug fixing
if %local_time%==%local_time% (set this_restart=1)
if %local_time%==%restart_2_time% (set this_restart=2)
if %local_time%==%restart_3_time% (set this_restart=3)
if %local_time%==%restart_4_time% (set this_restart=4)
if %this_restart%==4 (set nxt_restart=1) else (set /a nxt_restart=%this_restart%+1)
set backup_final=%backup_location%[%local_day%.%local_month% - %local_hours%h%local_minutes%m] %backup_name%"
REM TODO These next two don't need to be updated 
set msg_restartStatusTrue=%msg_restartStatusTrue_part_1%%this_restart% %msg_restartStatusTrue_part_2%
set msg_restart_done=%msg_restart_done_part_1%%this_restart%%msg_restart_done_part_2%%nxt_restart%
REM Don't lose time looping throught every restart every time
if "%restart_1_done%"=="false" (goto :fstRestart)
if "%restart_2_done%"=="false" (goto :sndRestart)
if "%restart_3_done%"=="false" (goto :trdRestart)
if "%restart_4_done%"=="false" (goto :fthRestart)

::First Restart::
:fstRestart
if "%restart_1_done%"=="false"  (
	if %local_time%==%restart_1_time% (
		echo %msg_restartingServer%
		echo %msg_restartingServer% >> %log_final%
		echo %title_main%
		taskkill /F /FI "WINDOWTITLE eq %title_main%" /T >> %log_final%
		if "%stopTestServerAlways%"=="true" (
				if "%isTestServerRunning%"=="true" (
					echo %msg_closingTestServer%
					echo %msg_closingTestServer% >> %log_final%
					taskkill /F /FI "WINDOWTITLE eq %title_test%" /T >> %log_final%
					tasklist /FI "WINDOWTITLE eq %title_test%" 2>NUL | find /I /N "cmd.exe">NUL
					if "%ERRORLEVEL%"=="0" (set isTestServerRunning=true) else (set isTestServerRunning=false)
				)
			)
			if "%clearCacheAlways%"=="true" (
				echo %msg_deletingCache%
				echo %msg_deletingCache% >> %log_final%
				rmdir %location%cache\files /s /q >> %log_final%
			)
			if "%stopBrowser%"=="true" (
				if "%isBrowserRunnig%"=="true" (
					echo %msg_closingBrowser%
					echo %msg_closingBrowser% >> %log_final%
					taskkill /F /IM %browserIm% /T >> %log_final%
					tasklist /FI "IMAGENAME eq %browserIm%" 2>NUL | find /I /N "%browserIm%">NUL
					if "%ERRORLEVEL%"=="0" (set isBrowserRunnig=true) else (set isBrowserRunnig=false)
				)
			)
			if "%backup%"=="true" (
				echo %msg_doingBackup%
				echo %msg_doingBackup% >> %log_final%
				if "%lang%"=="br" (
					mkdir %backup_final% 
				)
				if "%lang%"=="en" (
					mkdir %backup_final% 
				)
				echo %msg_copyingCfg% %backup_final% 
				echo %msg_copyingCfg% %backup_final% >> %log_final%
				copy %location%server.cfg %backup_final% >> %log_final% 
				echo %msg_cfgCopied% %backup_final% 
				echo %msg_cfgCopied% %backup_final% >> %log_final%
				echo %msg_copyingFolder% %backup_final% 
				echo %msg_copyingFolder% %backup_final% >> %log_final%
				xcopy %location%resources %backup_final% /E /Q >> %log_final%
				echo %msg_folderCopied% %backup_final% 
				echo %msg_folderCopied% %backup_final% >> %log_final%
				echo %msg_backupDone%
				echo %msg_backupDone% >> %log_final%
			)
		echo %msg_restartStatusTrue% 
		echo %msg_restartStatusTrue%  >> %log_final%
		echo %msg_restart_done%
		echo %msg_restart_done% >> %log_final%
		set restart_1_done=true
		start %startServer_bat_location%
		goto :sndRestart
	) else (goto :getTime)
) else (goto :sndRestart)

::Second Restart::
:sndRestart
if "%restart_2_done%"=="false"  (
	if %local_time%==%restart_2_time% (
		echo %msg_restartingServer%
		echo %msg_restartingServer% >> %log_final%
		taskkill /F /FI "WINDOWTITLE eq %title_main%" /T >> %log_final%
		if "%stopTestServerAlways%"=="true" (
				if "%isTestServerRunning%"=="true" (
					echo %msg_closingTestServer%
					echo %msg_closingTestServer% >> %log_final%
					taskkill /F /FI "WINDOWTITLE eq %title_test%" /T >> %log_final%
					tasklist /FI "WINDOWTITLE eq %title_test%" 2>NUL | find /I /N "cmd.exe">NUL
					if "%ERRORLEVEL%"=="0" (set isTestServerRunning=true) else (set isTestServerRunning=false)
				)
			)
			if "%clearCacheAlways%"=="true" (
				echo %msg_deletingCache%
				echo %msg_deletingCache% >> %log_final%
				rmdir %location%cache\files /s /q >> %log_final%
			)
			if "%stopBrowser%"=="true" (
				if "%isBrowserRunnig%"=="true" (
					echo %msg_closingBrowser%
					echo %msg_closingBrowser% >> %log_final%
					taskkill /F /IM %browserIm% /T >> %log_final%
					tasklist /FI "IMAGENAME eq %browserIm%" 2>NUL | find /I /N "%browserIm%">NUL
					if "%ERRORLEVEL%"=="0" (set isBrowserRunnig=true) else (set isBrowserRunnig=false)
				)
			)
			if "%backup%"=="true" (
				echo %msg_doingBackup%
				echo %msg_doingBackup% >> %log_final%
				if "%lang%"=="br" (
					mkdir %backup_final% 
				)
				if "%lang%"=="en" (
					mkdir %backup_final% 
				)
				echo %msg_copyingCfg% %backup_final% 
				echo %msg_copyingCfg% %backup_final% >> %log_final%
				copy %location%server.cfg %backup_final% >> %log_final% 
				echo %msg_cfgCopied% %backup_final% 
				echo %msg_cfgCopied% %backup_final% >> %log_final%
				echo %msg_copyingFolder% %backup_final% 
				echo %msg_copyingFolder% %backup_final% >> %log_final%
				xcopy %location%resources %backup_final% /E /Q >> %log_final%
				echo %msg_folderCopied% %backup_final% 
				echo %msg_folderCopied% %backup_final% >> %log_final%
				echo %msg_backupDone%
				echo %msg_backupDone% >> %log_final%
			)
		echo %msg_restartStatusTrue% 
		echo %msg_restartStatusTrue%  >> %log_final%
		echo %msg_restart_done%
		echo %msg_restart_done% >> %log_final%
		set restart_2_done=true
		start %startServer_bat_location%
		goto :trdRestart
	) else (goto :getTime)
) else (goto :trdRestart)

::Third Restart::
:trdRestart
if "%restart_3_done%"=="false"  (
	if %local_time%==%restart_3_time% (
		echo %msg_restartingServer%
		echo %msg_restartingServer% >> %log_final%
		taskkill /F /FI "WINDOWTITLE eq %title_main%" /T >> %log_final%
		if "%stopTestServerAlways%"=="true" (
				if "%isTestServerRunning%"=="true" (
					echo %msg_closingTestServer%
					echo %msg_closingTestServer% >> %log_final%
					taskkill /F /FI "WINDOWTITLE eq %title_test%" /T >> %log_final%
					tasklist /FI "WINDOWTITLE eq %title_test%" 2>NUL | find /I /N "cmd.exe">NUL
					if "%ERRORLEVEL%"=="0" (set isTestServerRunning=true) else (set isTestServerRunning=false)
				)
			)
			if "%clearCacheAlways%"=="true" (
				echo %msg_deletingCache%
				echo %msg_deletingCache% >> %log_final%
				rmdir %location%cache\files /s /q >> %log_final%
			)
			if "%stopBrowser%"=="true" (
				if "%isBrowserRunnig%"=="true" (
					echo %msg_closingBrowser%
					echo %msg_closingBrowser% >> %log_final%
					taskkill /F /IM %browserIm% /T >> %log_final%
					tasklist /FI "IMAGENAME eq %browserIm%" 2>NUL | find /I /N "%browserIm%">NUL
					if "%ERRORLEVEL%"=="0" (set isBrowserRunnig=true) else (set isBrowserRunnig=false)
				)
			)
			if "%backup%"=="true" (
				echo %msg_doingBackup%
				echo %msg_doingBackup% >> %log_final%
				if "%lang%"=="br" (
					mkdir %backup_final% 
				)
				if "%lang%"=="en" (
					mkdir %backup_final% 
				)
				echo %msg_copyingCfg% %backup_final% 
				echo %msg_copyingCfg% %backup_final% >> %log_final%
				copy %location%server.cfg %backup_final% >> %log_final% 
				echo %msg_cfgCopied% %backup_final% 
				echo %msg_cfgCopied% %backup_final% >> %log_final%
				echo %msg_copyingFolder% %backup_final% 
				echo %msg_copyingFolder% %backup_final% >> %log_final%
				xcopy %location%resources %backup_final% /E /Q >> %log_final%
				echo %msg_folderCopied% %backup_final% 
				echo %msg_folderCopied% %backup_final% >> %log_final%
				echo %msg_backupDone%
				echo %msg_backupDone% >> %log_final%
			)
		echo %msg_restartStatusTrue% 
		echo %msg_restartStatusTrue%  >> %log_final%
		echo %msg_restart_done%
		echo %msg_restart_done% >> %log_final%
		set restart_3_done=true
		start %startServer_bat_location%
		goto :fthRestart
	) else (goto :getTime)
) else (goto :fthRestart)

::Fourth Restart::
:fthRestart
if "%restart_4_done%"=="false"  (
	if %local_time%==%restart_4_time% (
		echo %msg_restartingServer%
		echo %msg_restartingServer% >> %log_final%
		taskkill /F /FI "WINDOWTITLE eq %title_main%" /T >> %log_final%
		if "%stopTestServerAlways%"=="true" (
				if "%isTestServerRunning%"=="true" (
					echo %msg_closingTestServer%
					echo %msg_closingTestServer% >> %log_final%
					taskkill /F /FI "WINDOWTITLE eq %title_test%" /T >> %log_final%
					tasklist /FI "WINDOWTITLE eq %title_test%" 2>NUL | find /I /N "cmd.exe">NUL
					if "%ERRORLEVEL%"=="0" (set isTestServerRunning=true) else (set isTestServerRunning=false)
				)
			)
			if "%clearCacheAlways%"=="true" (
				echo %msg_deletingCache%
				echo %msg_deletingCache% >> %log_final%
				rmdir %location%cache\files /s /q >> %log_final%
			)
			if "%stopBrowser%"=="true" (
				if "%isBrowserRunnig%"=="true" (
					echo %msg_closingBrowser%
					echo %msg_closingBrowser% >> %log_final%
					taskkill /F /IM %browserIm% /T >> %log_final%
					tasklist /FI "IMAGENAME eq %browserIm%" 2>NUL | find /I /N "%browserIm%">NUL
					if "%ERRORLEVEL%"=="0" (set isBrowserRunnig=true) else (set isBrowserRunnig=false)
				)
			)
			if "%backup%"=="true" (
				echo %msg_doingBackup%
				echo %msg_doingBackup% >> %log_final%
				if "%lang%"=="br" (
					mkdir %backup_final% 
				)
				if "%lang%"=="en" (
					mkdir %backup_final% 
				)
				echo %msg_copyingCfg% %backup_final% 
				echo %msg_copyingCfg% %backup_final% >> %log_final%
				copy %location%server.cfg %backup_final% >> %log_final% 
				echo %msg_cfgCopied% %backup_final% 
				echo %msg_cfgCopied% %backup_final% >> %log_final%
				echo %msg_copyingFolder% %backup_final% 
				echo %msg_copyingFolder% %backup_final% >> %log_final%
				xcopy %location%resources %backup_final% /E /Q >> %log_final%
				echo %msg_folderCopied% %backup_final% 
				echo %msg_folderCopied% %backup_final% >> %log_final%
				echo %msg_backupDone%
				echo %msg_backupDone% >> %log_final%
			)
		echo %msg_restartStatusTrue% 
		echo %msg_restartStatusTrue%  >> %log_final%
		echo %msg_restart_done%
		echo %msg_restart_done% >> %log_final%
		echo.>> %log_final%
		echo %msg_lastRestart_done%
		echo %msg_lastRestart_done% >> %log_final%
		echo.>> %log_final%
		set restart_4_done=true
		goto :start
	) else (goto :getTime)
) else (goto :start)

:pause
pause 