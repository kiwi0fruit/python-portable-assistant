@echo off
:: inverse order of channels:
"%_conda%" config --env --add channels conda-forge
"%_conda%" config --env --add channels defaults

:: "%_python%" -m ipykernel install --user --name %env%
