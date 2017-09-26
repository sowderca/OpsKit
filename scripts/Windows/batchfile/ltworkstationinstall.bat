@echo off

:: Check if 64/23 bit OS

if exist %windir%\syswow64 goto 64
goto32


:: 32 bit installer
:32
echo Downloading dotNetFramework
if not exist C:\NetFx20SP1_x86 call dotNet32dl.vbs /wait
:: install the dotnet components
call C:\NetFx20SP1_x86 /q /wait
call Agent_Installer.exe /wait
goto exit


:64
echo Downloading dotnet framework
if not exist C:\NetFx20SP1_x64 call dotNet64dl.vbs /wait
:: install the dotnet components
call C:\NetFx20SP1_x64 /q /wait
call Agent_Installer.exe /wait
goto exit

:exit
exit
