set PathBackup=%PATH%

set PYTHONPATH=%pypath%\%pyfolder%
set PATH=%PathBackup%;%PYTHONPATH%;%PYTHONPATH%\Scripts;%PYTHONPATH%\Library\bin;

set here=%~dp0
set thispath=%here:~0,-1%


set xbit=ERROR
IF %pyfolder%==Miniconda64 (
	set xbit=64bit
)
IF %pyfolder%==Miniconda32 (
	set xbit=32bit
)

set workdir=%pyout%\%pyapp%-%xbit%-%pyver%.7z
set "debug="
::set debug=pause
set funcs=%thispath%\files\functions.cmd
set psfuncs=%thispath%\files\functions.psm1


call "%funcs%" checkvars
pause


IF exist "%workdir%\config" rd /s /q "%workdir%\config"
IF exist "%workdir%\apps" rd /s /q "%workdir%\apps"
IF exist "%workdir%\%pyfolder%\pkgs" rd /s /q "%workdir%\%pyfolder%\pkgs"
cmd "/c activate %pyenv%_%pyver% && conda remove --force mkl && deactivate"


echo Read the log if needed and press any key to continue.
%debug%


robocopy "%pypath%\%pyfolder%" "%workdir%\%pyfolder%" /mir /xd "%pypath%\%pyfolder%\envs" "%pypath%\%pyfolder%\pkgs"
robocopy "%pypath%\%pyfolder%\envs\%pyenv%_%pyver%" "%workdir%\%pyfolder%\envs\%pyenv%_%pyver%" /mir
robocopy "%pypath%\%pyfolder%\pkgs\cache" "%workdir%\%pyfolder%\pkgs\cache" /e
robocopy "%pypath%\%pyfolder%\pkgs" "%workdir%\%pyfolder%\pkgs" urls.txt
robocopy "%thispath%\files\miniconda" "%workdir%" /e
IF exist "%thispath%\envs\%pyenv%\config" (
	robocopy "%thispath%\envs\%pyenv%\config" "%workdir%\config" /e
)


echo Read the log if needed and press any key to continue.
%debug%


robocopy "%thispath%\apps\%pyapp%" "%workdir%" /e /xf "shortcuts.ps1"
Powershell -executionpolicy remotesigned -File  "%thispath%\apps\%pyapp%\shortcuts.ps1"


:: MKL begin
set pypkgs=%workdir%\%pyfolder%\pkgs
IF exist "%pypkgs%\temp0" rd /s /q "%pypkgs%\temp0"
IF exist "%pypkgs%\temp" rd /s /q "%pypkgs%\temp"
mkdir "%pypkgs%\temp0"
mkdir "%pypkgs%\temp"

robocopy "%pypath%\%pyfolder%\pkgs" "%pypkgs%\temp0" mkl-0*.tar.bz2 mkl-1*.tar.bz2 mkl-2*.tar.bz2 mkl-3*.tar.bz2 mkl-4*.tar.bz2 mkl-5*.tar.bz2 mkl-6*.tar.bz2 mkl-7*.tar.bz2 mkl-8*.tar.bz2 mkl-9*.tar.bz2 /xd *
powershell -Command "gci '%pypkgs%\temp0' | select -last 1 | move-item -Destination '%pypkgs%\temp' -force"

cd /d "%pypkgs%\temp"
dir /B mkl*.tar.bz2 > 1.txt
for /f "tokens=* delims= " %%a in (1.txt) do (
	set mklfile=%%a
)
move "%pypkgs%\temp\%mklfile%" "%workdir%\%pyfolder%\Scripts"
IF exist "%pypkgs%\temp0" rd /s /q "%pypkgs%\temp0"
IF exist "%pypkgs%\temp" rd /s /q "%pypkgs%\temp"
:: MKL end


:: PPA begin
set assistant=%workdir%\License and Source and Info\Python portable assistant

echo Read the log if needed and press any key to continue.
%debug%

robocopy "%thispath%\apps\pyqtgraph2enaml" "%assistant%\apps\pyqtgraph2enaml" /e
robocopy "%thispath%\apps" "%assistant%\apps" *pyqtgraph2enaml.cmd /xd *
robocopy "%thispath%\envs\enaml_test" "%assistant%\envs\enaml_test" /e
robocopy "%thispath%\envs" "%assistant%\envs" *enaml_test.cmd /xd *
robocopy "%thispath%" "%assistant%" /e /xd "%thispath%\__hidden" "%thispath%\apps" "%thispath%\envs"
:: PPA end


echo Read the log if needed and press any key to continue.
%debug%


set targetpath=%workdir%\config\config.cmd
powershell -Command "(Get-Content '%targetpath%') -replace '__pyfolder', '%pyfolder%' | Set-Content '%targetpath%'"
powershell -Command "(Get-Content '%targetpath%') -replace '__pyenv', '%pyenv%' | Set-Content '%targetpath%'"
powershell -Command "(Get-Content '%targetpath%') -replace '__pyver', '%pyver%' | Set-Content '%targetpath%'"
set targetpath=%workdir%\config\mkl.cmd
powershell -Command "(Get-Content '%targetpath%') -replace '__mklfile', '%mklfile%' | Set-Content '%targetpath%'"


cmd "/c activate %pyenv%_%pyver% && conda install --force mkl && deactivate"


set PYTHONPATH=%workdir%\%pyfolder%
set PATH=%PathBackup%;%PYTHONPATH%;%PYTHONPATH%\Scripts;%PYTHONPATH%\Library\bin;

cmd "/c activate %pyenv%_%pyver% && pip uninstall mingwpy && deactivate"
cd /d "%workdir%\License and Source and Info"
cmd "/c activate %pyenv%_%pyver% && conda env export -n %pyenv%_%pyver% -f PackagesList.txt && deactivate"

pause
