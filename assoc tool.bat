@echo off&color f2&mode con lines=45 cols=145&title �ļ��������� -- by xw

echo.
echo.-------------- �ļ���������ʹ��˵�� --------------
echo.
echo ������ţ�
echo 1 goto reg_menu
echo 2 goto reg_ext
echo 3 goto reg_ico
echo 4 goto un_reg_ext
echo 5 goto un_reg_menu
echo 6 exit
echo.

echo �������󣬵���˴��ڰ� enter ����
REM set /p exe_path=
set exe_path="E:\git2\bat tool\notepad 2.exe"
for %%i in (%exe_path%) do (set exe_name=%%~nxi)
for %%i in (%exe_path%) do (set temp=%%~dpi)
set exe_name=%exe_name:.exe=%
set exe_path=%exe_path:"=%
set ext_path=%temp%ext.txt
set ext_tag=text_file
if not exist "%ext_path%" (echo.&echo ע�⣺&echo ��չ���б��ļ� "%ext_path%" �����ڡ�&pause>nul&exit)


:begin
echo.
set u=&set /p u=���������ţ�
if "%u%" == "1" goto reg_menu
if "%u%" == "2" goto reg_ext
if "%u%" == "3" goto reg_ico
if "%u%" == "4" goto un_reg_ext
if "%u%" == "5" goto un_reg_menu
if "%u%" == "6" exit
goto begin


:reg_menu
reg add "hkcr\*\shell\%exe_name%" /ve /d "ʹ�� %exe_name% ��" /f >nul 2>nul
reg add "hkcr\*\shell\%exe_name%\command" /ve /d "%exe_path% """%%1%"""" /f >nul 2>nul
echo.&echo ע���Ҽ��˵���� &echo.&goto begin

:un_reg_menu
reg delete "hkcr\*\shell\%exe_name%" /f >nul 2>nul
echo.&echo ж���Ҽ��˵���� &echo.&goto begin

:reg_ico
for /f "eol=; delims=" %%e in ('type "%ext_path%"') do (
  (
    reg add "hkcr\%ext_tag%.%%e\defaulticon" /ve /d "%cd%\icons\%%e.ico" /f
    echo reg add "hkcr\%ext_tag%.%%e\defaulticon" /ve /d "%cd%\icons\%%e.ico" /f
  )
)
taskkill /f /im explorer.exe >nul 2>nul&start explorer.exe
echo.&echo ע��ͼ����� &echo.&goto begin

:reg_ext
for /f "eol=; delims=" %%e in ('type "%ext_path%"') do (
  (
    reg add "hkcr\%ext_tag%.%%e" /ve /d "%%e" /f
    reg add "hkcr\%ext_tag%.%%e\defaulticon" /ve /d "%exe_path%" /f
    reg add "hkcr\%ext_tag%.%%e\shell\open\command" /ve /d """"%exe_path%""" """%%1%"""" /f
    REM pause&goto begin
    for /f "skip=2 tokens=1,2,* delims= " %%a in ('reg query "hkcr\.%%e" /ve') do (
      if not "%%c" == "%ext_tag%" (
        reg add "hkcr\.%%e" /v "ext_backup" /d "%%c" /f >nul 2>nul
      )
    )
  )
  assoc .%%e=%ext_tag%.%%e
)
echo.&echo ע����չ����� &echo.&goto begin


:un_reg_ext
reg delete "hkcr\%ext_tag%" /f >nul 2>nul
for /f "eol=; delims=" %%e in ('type "%ext_path%"') do (
  (
    for /f "skip=2 tokens=1,2,* delims= " %%a in ('reg query "hkcr\.%%e" /v "ext_backup"') do (
      reg add "hkcr\%ext_tag%.%%e" /ve /d "%%c" /f >nul 2>nul
      reg delete "hkcr\%ext_tag%.%%e" /v "ext_backup" /f >nul 2>nul
    )
  )
)
taskkill /f /im explorer.exe >nul 2>nul&start explorer.exe
echo.&echo ж����չ����� &echo.&goto begin

