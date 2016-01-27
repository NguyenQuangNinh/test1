@echo off
@SET PATH=%PATH%;C:\flex_sdk\bin
@SET BASE_OUTPUT=..\bin
@SET BASE_SRC=..\src
@SET LINK_REPORT=link_report.xml

echo :: Compiling Fonts::
mxmlc %BASE_SRC%\game\fonts\ViFonts.as -static-link-runtime-shared-libraries=true -load-config+=build_config.xml -link-report=%LINK_REPORT% -o %BASE_OUTPUT%\resource\fonts\vi_styles.font

pause