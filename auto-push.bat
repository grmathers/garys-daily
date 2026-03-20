@echo off
:: Gary's Daily — Auto Push to GitHub Pages
:: This runs via Windows Task Scheduler after Claude's daily content update
:: Scheduled for 7:15 AM daily (Claude runs at 7:00 AM)

cd /d "C:\Users\wmars\OneDrive\Documents\Gary Stuff\Claude\garys-daily-repo"

:: Check if this is a git repo
if not exist ".git" (
    echo No .git folder found. Run initial setup first.
    exit /b 1
)

:: Stage, commit, and push
"C:\Program Files\Git\bin\git.exe" add .
"C:\Program Files\Git\bin\git.exe" commit -m "Daily update: %date:~-4%-%date:~4,2%-%date:~7,2%"
"C:\Program Files\Git\bin\git.exe" push origin main
