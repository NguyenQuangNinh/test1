@echo off
@SET PATH=%PATH%;D:\Apache Flex SDK\bin
@SET BASE_OUTPUT=..\..\bin
@SET BASE_SRC=..\..\src
@SET LINK_REPORT=link_report.xml

echo :: Clean up ::
del %BASE_OUTPUT%\*.cache
del %BASE_OUTPUT%\main.swf

echo :: Compiling Main ::
mxmlc %BASE_SRC%\game\Main.as -load-config+=build_config_telemetry.xml -link-report=%LINK_REPORT% -o %BASE_OUTPUT%\main.swf

pause