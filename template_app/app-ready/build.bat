set "script_dir=%~dp0"
cd /d "%script_dir%"

python setup.py sdist

start dist
