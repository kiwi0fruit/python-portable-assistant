set here=%~dp0
set thispath=%here:~0,-1%
call "%thispath%\config\config.cmd"

set PYTHONPATH=%thispath%\%pyfolder%
set PATH=%PYTHONPATH%;%PYTHONPATH%\Scripts;%PYTHONPATH%\Library\bin;%PATH%

cd /d %thispath%\%pyfolder%\Scripts
cmd /k "activate %pyenv%_%pyver%"
