@echo off&color f2&mode con lines=45 cols=145&title �ļ��������� -- by xw

call :doc

echo  �������󣬵���˴��ڰ� enter ����
set /p exe_path=
for %%i in (%exe_path%) do (set exe_name=%%~nxi)
for %%i in (%exe_path%) do (set temp=%%~dpi)
set exe_name=%exe_name:.exe=%
set exe_path=%exe_path:"=%
set ext_path=%temp%ext.txt
set ext_tag=text_file

call :doc &if not exist "%ext_path%" (echo  ע�⣺��չ���б��ļ� "%ext_path%" �����ڡ�&pause>nul&exit)


:begin
echo.&set u=&set /p u= ���������ţ�
if "%u%" == "1" goto reg_menu
if "%u%" == "2" goto reg_ext
if "%u%" == "3" goto reg_ico
if "%u%" == "4" goto un_reg_ext
if "%u%" == "5" goto un_reg_menu
if "%u%" == "6" exit
call :doc &goto begin


:reg_menu
reg add "hkcr\*\shell\%exe_name%" /ve /d "ʹ�� %exe_name% ��" /f >nul 2>nul
reg add "hkcr\*\shell\%exe_name%\command" /ve /d "%exe_path% """%%1%"""" /f >nul 2>nul
call :doc &echo.&echo  * ����Ҽ��˵���� &echo.&goto begin

:un_reg_menu
reg delete "hkcr\*\shell\%exe_name%" /f >nul 2>nul
call :doc &echo.&echo  * ȡ������Ҽ��˵���� &echo.&goto begin

:reg_ico
for /f "eol=; delims=" %%e in ('type "%ext_path%"') do (
  (
    if exist "%cd%\icons\%%e.ico" (
      reg add "hkcr\%ext_tag%.%%e\defaulticon" /ve /d "%cd%\icons\%%e.ico" /f >nul 2>nul
    )
  )
)
taskkill /f /im explorer.exe >nul 2>nul&start explorer.exe
call :doc &echo.&echo  * ����ͼ����� &echo.&goto begin

:reg_ext
for /f "eol=; delims=" %%e in ('type "%ext_path%"') do (
  (
    reg add "hkcr\%ext_tag%.%%e" /ve /d "%%e" /f >nul 2>nul
    reg add "hkcr\%ext_tag%.%%e\defaulticon" /ve /d "%exe_path%" /f >nul 2>nul
    reg add "hkcr\%ext_tag%.%%e\shell\open\command" /ve /d """"%exe_path%""" """%%1%"""" /f >nul 2>nul
    for /f "skip=2 tokens=1,2,* delims= " %%a in ('reg query "hkcr\.%%e" /ve') do (
      if not "%%c" == "%ext_tag%" (
        reg add "hkcr\.%%e" /v "ext_backup" /d "%%c" /f >nul 2>nul
      )
    )
  )
  assoc .%%e=%ext_tag%.%%e
)
call :doc &echo.&echo  * ������չ����� &echo.&goto begin


:un_reg_ext
for /f "eol=; delims=" %%e in ('type "%ext_path%"') do (
  (
    reg delete "hkcr\%ext_tag%.%%e" /f >nul 2>nul
    for /f "skip=2 tokens=1,2,* delims= " %%a in ('reg query "hkcr\.%%e" /v "ext_backup"') do (
      reg add "hkcr\%ext_tag%.%%e" /ve /d "%%c" /f >nul 2>nul
      reg delete "hkcr\%ext_tag%.%%e" /v "ext_backup" /f >nul 2>nul
    )
  )
)
taskkill /f /im explorer.exe >nul 2>nul&start explorer.exe
call :doc &echo.&echo  * ȡ��������չ����� &echo.&goto begin


:doc
cls&echo.
echo. -------------- �ļ���������ʹ��˵�� --------------
echo.
echo  ������ţ�
echo   1 ����Ҽ��˵�
echo   2 ������չ��(�����ͬĿ¼�� ext.txt �ļ���)
echo   3 ����ͼ��
echo   4 ȡ��������չ��
echo   5 ȡ������Ҽ��˵�
echo   6 �˳�
echo.
goto :eof
