@echo off&color 2f&mode con lines=45 cols=145&title �ļ���������

echo.
echo.-------------- �ļ���������ʹ��˵�� --------------
echo.
echo ������ţ�
echo   1: ����Ҽ��˵�
echo   2: ɾ���Ҽ��˵�
echo   3: ������չ��(�����ͬĿ¼�� ext.txt �ļ���)
echo   4: ɾ����չ��
echo   5: �˳�
echo.

echo �������󣬵���˴��ڰ� enter ����
set /p exe_path=
for %%i in (%exe_path%) do (set file_name=%%~nxi)
for %%i in (%exe_path%) do (set file_path=%%~dpi)
set exe_path=%exe_path:"=%
set ext_path=%file_path%ext.txt
if not exist "%ext_path%" (echo.&echo ע�⣺&echo ��չ���б��ļ� "%ext_path%" �����ڡ�&pause>nul&exit)


:begin
echo.
set u=&set /p u=���������ţ�
if "%u%" == "1" goto reg_menu
if "%u%" == "2" goto un_reg_menu
if "%u%" == "3" goto text_file
if "%u%" == "4" goto un_text_file
if "%u%" == "5" exit
goto begin


:reg_menu
reg add "hkcr\*\shell\%file_name%" /ve /d "ʹ�� %file_name% ��" /f >nul 2>nul
reg add "hkcr\*\shell\%file_name%\command" /ve /d "%exe_path% """%%1%"""" /f >nul 2>nul
echo.&echo ע���Ҽ��˵���� &echo.&goto begin

:un_reg_menu
reg delete "hkcr\*\shell\%file_name%" /f >nul 2>nul
echo.&echo ж���Ҽ��˵���� &echo.&goto begin

:text_file
reg add "hkcr\text_file" /ve /d "�ı��ĵ�" /f >nul 2>nul
reg add "hkcr\text_file\defaulticon" /ve /d "%exe_path%" /f >nul 2>nul
reg add "hkcr\text_file\shell\open\command" /ve /d "%exe_path% """%%1%"""" /f >nul 2>nul

for /f "eol=; delims=" %%e in ('type "%ext_path%"') do (
  (
    for /f "skip=2 tokens=1,2,* delims= " %%a in ('reg query "hkcr\.%%e" /ve') do (
      if not "%%c" == "text_file" (
        reg add "hkcr\.%%e" /v "text_backup" /d "%%c" /f >nul 2>nul
      )
    )
  )
  assoc .%%e=text_file
)
echo.&echo ע����չ����� &echo.&goto begin


:un_text_file
reg delete "hkcr\text_file" /f >nul 2>nul
for /f "eol=; delims=" %%e in ('type "%ext_path%"') do (
  (
    for /f "skip=2 tokens=1,2,* delims= " %%a in ('reg query "hkcr\.%%e" /v "text_backup"') do (
      reg add "hkcr\.%%e" /ve /d "%%c" /f >nul 2>nul
      reg delete "hkcr\.%%e" /v "text_backup" /f >nul 2>nul
    )
  )
)
echo.&echo ж����չ����� &echo.&goto begin

