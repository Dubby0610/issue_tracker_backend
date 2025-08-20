@echo off
rem Windows batch file to start the Rails server
echo Starting Rails server on port 3001...
cd /d "%~dp0"
ruby bin/rails server -p 3001
pause
