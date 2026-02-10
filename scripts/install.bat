::Script to install Python, create a virtual environment and install dependencies
::Any argument passed will be passed to the venv command

@echo off
where python >nul 2>&1
if errorlevel 1 goto :installPy

:afterPy
::ensure pip and venv are installed
python -m pip -h >nul 2>&1
if errorlevel 1 goto :brokenInstallation
python -m venv -h >nul 2>&1
if errorlevel 1 goto :brokenInstallation

::make make sure we are in the project root
cd %~dp0\..

cd backend
::create and enable venv
cd .venv
if errorlevel 1 ( python -m venv .venv %1 ) else cd ..
call .venv\Scripts\activate.bat

::install dependencies
pip install -r requirements.txt >nul
cd ..

call backend\.venv\Scripts\deactivate.bat

echo Installation completed
goto :EOF

:installPy
echo Installing Python 3.13
winget install --id=Python.Python.3.13 --source=winget
goto afterPy

:brokenInstallation
echo Installation failed: >2
python -m pip -h >nul 2>&1
if errorlevel 1 echo pip is not installed >2
python -m venv -h >nul 2>&1
if errorlevel 1 echo venv is not installed >2
echo Please install them manually>2
echo. >2
echo The installation of python has failed.
pause
exit /b 1
