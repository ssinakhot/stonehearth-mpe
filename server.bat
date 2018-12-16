@ECHO OFF

:: Multiplayer Client Options
SET remote_server_enabled=false
::SET remote_server_address="127.4.0.1"
SET remote_server_port=57094

:: Multiplayer Server Options
SET server_enabled=true
::SET server_ip=0.0.5.0
::SET server_port=57095
SET load_save_file=""

:: World Generation Game Options
call :random seed1
call :random seed2
call :random seed3
::SET seed=%seed1%%seed2%%seed3%
::SET x=5
::SET y=5
::SET width=12
::SET height=8
:: "temperate", "desert", "artic", "highlands" (ACE mod)
::SET biome="artic"
:: "normal", "peaceful", "hard"
::SET game_mode="hard"

Stonehearth.exe ^
    --multiplayer.remote_server.enabled=%remote_server_enabled% ^
::    --multiplayer.remote_server.ip=%remote_server_ip% ^
    --multiplayer.remote_server.port=%remote_server_port% ^
    --multiplayer.server.headless.enabled=%server_enabled% ^
    --multiplayer.server.headless.saveid=%load_save_file% ^
::    --multiplayer.server.ip=%server_ip% ^
::    --multiplayer.server.port=%server_port% ^
::    --multiplayer.server.headless.options.seed=%seed% ^
::    --multiplayer.server.headless.options.x=%x% ^
::    --multiplayer.server.headless.options.y=%y% ^
::    --multiplayer.server.headless.options.width=%width% ^
::    --multiplayer.server.headless.options.height=%height% ^
::    --multiplayer.server.headless.options.biome_src=%biome% ^
::    --multiplayer.server.headless.options.game_mode=%game_mode% 
goto :eof

:random
:: Version 1: Generates a random number between 1000 and 9999
setlocal
set /a nr=%random%*899/32767+100
endlocal & set %1=%nr%
goto :eof