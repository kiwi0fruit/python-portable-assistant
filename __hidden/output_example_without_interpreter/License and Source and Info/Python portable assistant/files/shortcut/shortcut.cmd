if not "%minimized%"=="" goto :minimized
set minimized=true
start /min cmd /C "%~dpnx0"
goto :EOF
:minimized

set pyscript=__pyscript

set here=%~dp0
set thispath=%here:~0,-1%
call "%thispath%\config\config.cmd"
cd /d %thispath%\%pyfolder%\envs\%pyenv%_%pyver%
python "%thispath%\%pyscript%"
