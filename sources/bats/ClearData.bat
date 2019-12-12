@echo off

call bats/SetupApp.bat

cd %AppData%\%APP_ID%\Local Store\
del /F /Q #SharedObjects\release.swf\user-data.sol
::del /F /Q config.xml

cd %~dp0 & cd ..