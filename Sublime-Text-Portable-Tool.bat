@echo off&color 2f&mode con lines=45 cols=145&title %exe_name% ��Я�湤��
set exe_path=notepad2.exe
set exe_name=%exe_path%
set ext_list=ext.txt


if not exist %exe_path% (echo Ŀ����򲻴��ڣ���ѱ����߸��Ƶ� %exe_path% ���ڵ�Ŀ¼���У� &pause>nul&exit)
if not exist %ext_list% (echo Ŀ����򲻴��ڣ���ѱ����߸��Ƶ� %ext_list% ���ڵ�Ŀ¼���У� &pause>nul&exit)


echo.
echo.%exe_name% ��Я�湤�߰�ʹ��˵��
echo.
echo ������ţ�
echo   1: ����Ҽ��˵�;
echo   2: ɾ���Ҽ��˵�;
echo   3: ������չ��(��չ��������ͬĿ¼�� %ext_list% �ļ���);
echo   4: ɾ����չ��;
echo   5: �˳�;
echo.

:begin
set u=&set /p u=���������Ų��� enter ����
if "%u%" == "1" goto reg_menu
if "%u%" == "2" goto un_reg_menu
if "%u%" == "3" goto text_file
if "%u%" == "4" goto un_text_file
if "%u%" == "5" exit
goto begin



:reg_menu
reg add "hkcr\*\shell\%exe_name%" /ve /d "ʹ�� %exe_name% ��" /f
reg add "hkcr\*\shell\%exe_name%\command" /ve /d "%cd%\%exe_path% """%%1%"""" /f
echo.&echo �ѳɹ�ע���Ҽ��˵� &echo.&goto begin



:un_reg_menu
reg delete "hkcr\*\shell\%exe_name%" /f
echo.&echo �ѳɹ�ж���Ҽ��˵� &echo.&goto begin

:text_file
reg add "hkcr\text_file" /ve /d "�ı��ĵ�" /f
reg add "hkcr\text_file\defaulticon" /ve /d "%cd%\%exe_path%" /f
reg add "hkcr\text_file\shell\open\command" /ve /d "%cd%\%exe_path% """%%1%"""" /f
for /f "eol=;" %%e in (%ext_list%) do (
    (for /f "skip=2 tokens=1,2,* delims= " %%a in ('reg query "hkcr\.%%e" /ve') do (
      if not "%%c" == "text_file" (
        reg add "hkcr\.%%e" /v "text_backup" /d "%%c" /f
      )
    ))
    assoc .%%e=text_file
  )
echo.&echo �ѳɹ�ע����չ�� &echo.&goto begin



:un_text_file
reg delete "hkcr\text_file" /f
for /f "eol=;" %%e in (%ext_list%) do (
    (for /f "skip=2 tokens=1,2,* delims= " %%a in ('reg query "hkcr\.%%e" /v "text_backup"') do (
      reg add "hkcr\.%%e" /ve /d "%%c" /f
      reg delete "hkcr\.%%e" /v "text_backup" /f
    ))
  )
echo.&echo �ѳɹ�ж����չ�� &echo.&goto begin

