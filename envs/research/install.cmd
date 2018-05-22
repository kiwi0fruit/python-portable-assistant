::@echo off

cd /d "%envcache%"
::set tensorflow=tensorflow-<...>.whl
set pkgs=pandoctools

::# Fix setuptools - needed for proper work of 'pipResolve':
call conda remove --force setuptools
call conda install --force --copy setuptools
pip install --ignore-installed setuptools

:: Check pip dependencies:
call "%funcs%" pipResolve "%pkgs%"
@pause