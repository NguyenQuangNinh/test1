@echo off
@SET PATH=%PATH%;D:\Apache Flex SDK\bin;.\..\7za
@SET BASE_OUTPUT=..\..\bin
@SET BASE_SRC=..\..\src
@SET LINK_REPORT=link_report.xml

echo :: Clean up ::
del %BASE_OUTPUT%\*.cache
del %BASE_OUTPUT%\resource\res.dat

echo :: Zipping ::
7za a %BASE_OUTPUT%\main.zip %BASE_OUTPUT%\main.swf
7za a %BASE_OUTPUT%\resource\res.zip %BASE_OUTPUT%\resource\xml %BASE_OUTPUT%\resource\txt
del %BASE_OUTPUT%\main.swf
rename %BASE_OUTPUT%\main.zip main.swf
rename %BASE_OUTPUT%\resource\res.zip res.dat

pause