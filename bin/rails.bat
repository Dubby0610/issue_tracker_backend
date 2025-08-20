@echo off
rem Windows batch file to run Rails commands
cd /d "%~dp0.."
ruby bin/rails %*
