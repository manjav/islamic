@echo off
:: Set working dir
cd %~dp0 & cd ..

:: Get date with this template =>mouth day hours minutes seconds
set DATE=%date:~-10,2%%date:~-7,2%%time:~-11,2%%time:~-8,2%
:: Replace space with 0
for %%a in (%DATE: =0%) do set DATE=%%a

:: Application descriptor
set VER_ID=0.9.200
set VER_LABEL=%VER_ID%.%DATE%
set APP_ID=com.gerantech.islamic

:: Game Analytics
set GA_KEY_AND=GA_KEY_AND
set GA_SEC_AND=GA_SEC_AND
set GA_KEY_IOS=GA_KEY_IOS
set GA_SEC_IOS=GA_SEC_IOS

:: Debugging using a custom IP
set DEBUG_IP=