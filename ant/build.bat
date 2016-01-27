@echo off
@SET PATH=%PATH%;C:\flex_sdk\bin
@SET BASE_OUTPUT=..\bin
@SET BASE_SRC=..\src
@SET LINK_REPORT=link_report.xml

echo :: Compiling Launcher ::
mxmlc %BASE_SRC%\game\Launcher.as -load-config+=build_config.xml -static-link-runtime-shared-libraries=true -link-report=%LINK_REPORT% -o %BASE_OUTPUT%\launcher.swf 

echo :: Compiling Main ::
mxmlc %BASE_SRC%\game\Main.as -load-config+=build_config.xml -link-report=%LINK_REPORT% -o %BASE_OUTPUT%\main.swf

pause