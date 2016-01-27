@echo off
@SET PATH=%PATH%;D:\Apache Flex SDK\bin
@SET BASE_OUTPUT=..\..\bin
@SET BASE_SRC=..\..\src
@SET LINK_REPORT=link_report.xml

echo :: Clean up ::
del %BASE_OUTPUT%\*.cache
del %BASE_OUTPUT%\launcher.swf

echo :: Compiling Launcher ::
mxmlc %BASE_SRC%\game\Launcher.as -load-config+=build_config_telemetry.xml -static-link-runtime-shared-libraries=true -link-report=%LINK_REPORT% -o %BASE_OUTPUT%\launcher.swf 

pause