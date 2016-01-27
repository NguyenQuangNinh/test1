@echo off
@SET PATH=%PATH%;D:\softs\flex_sdk_4.6\bin;.\7za
@SET BASE_OUTPUT=..\bin
@SET BASE_SRC=..\src
@SET LINK_REPORT=link_report.xml

echo :: Clean up ::
del %BASE_OUTPUT%\*.cache
del %BASE_OUTPUT%\launcher.swf
del %BASE_OUTPUT%\main.swf
del %BASE_OUTPUT%\resource\res.dat
del %BASE_OUTPUT%\resource\ui_fx.dat
del %BASE_OUTPUT%\resource\ingame_fx.dat
del %BASE_OUTPUT%\resource\tutorial.dat
del %BASE_OUTPUT%\resource\tutorial1.dat

echo :: Compiling Launcher ::
mxmlc %BASE_SRC%\game\Launcher.as -load-config+=build_config.xml -static-link-runtime-shared-libraries=true -link-report=%LINK_REPORT% -o %BASE_OUTPUT%\launcher.swf 

echo :: Compiling Main ::
mxmlc %BASE_SRC%\game\Main.as -load-config+=build_config.xml -link-report=%LINK_REPORT% -o %BASE_OUTPUT%\main.swf

echo :: Zipping ::
7za a %BASE_OUTPUT%\main.zip %BASE_OUTPUT%\main.swf

cd %BASE_OUTPUT%\resource
..\..\ant\7za\7za a res.zip xml\ txt\ anim\font\

..\..\ant\7za\7za a ui_fx.zip anim\ui\level_up.banim
..\..\ant\7za\7za a ui_fx.zip anim\ui\ingame_rewards.banim
..\..\ant\7za\7za a ui_fx.zip anim\ui\hoanthanhnv.banim
..\..\ant\7za\7za a ui_fx.zip anim\ui\fx_truyencong_main.banim
..\..\ant\7za\7za a ui_fx.zip anim\ui\fx_truyencong_material.banim
..\..\ant\7za\7za a ui_fx.zip anim\ui\loadingmini.banim
..\..\ant\7za\7za a ui_fx.zip anim\character\dummy.banim

..\..\ant\7za\7za a ingame_fx.zip anim\ui\ui_tancong.banim
..\..\ant\7za\7za a ingame_fx.zip anim\ui\skill_text.banim
..\..\ant\7za\7za a ingame_fx.zip anim\ui\chien_thang.banim
..\..\ant\7za\7za a ingame_fx.zip anim\ui\choi_lai.banim
..\..\ant\7za\7za a ingame_fx.zip anim\ui\choi_tiep.banim
..\..\ant\7za\7za a ingame_fx.zip anim\ui\lenh_bai.banim
..\..\ant\7za\7za a ingame_fx.zip anim\ui\quay_lai.banim
..\..\ant\7za\7za a ingame_fx.zip anim\ui\that_bai.banim	

..\..\ant\7za\7za a tutorial.zip tutorial\moon.banim
..\..\ant\7za\7za a tutorial.zip tutorial\quach_tinh_tut.banim
..\..\ant\7za\7za a tutorial.zip tutorial\tay_doc_tut.banim
..\..\ant\7za\7za a tutorial.zip tutorial\nvbian.banim

..\..\ant\7za\7za a tutorial1.zip anim\character\nv_bian.banim
..\..\ant\7za\7za a tutorial1.zip anim\character\unique_auduongphong.banim
..\..\ant\7za\7za a tutorial1.zip anim\character\unique_auduongphong_minion_bac.banim
..\..\ant\7za\7za a tutorial1.zip anim\character\unique_quachtinh.banim
..\..\ant\7za\7za a tutorial1.zip anim\character\unique_hoangdung.banim
cd ..\..\ant

del %BASE_OUTPUT%\main.swf
rename %BASE_OUTPUT%\main.zip main.swf
rename %BASE_OUTPUT%\resource\res.zip res.dat
rename %BASE_OUTPUT%\resource\ui_fx.zip ui_fx.dat
rename %BASE_OUTPUT%\resource\ingame_fx.zip ingame_fx.dat
rename %BASE_OUTPUT%\resource\tutorial.zip tutorial.dat
rename %BASE_OUTPUT%\resource\tutorial1.zip tutorial1.dat

pause