@echo off
setlocal

set current_dir=%~dp0
set cur_path=%current_dir:~0,-1%

for /f "usebackq" %%X in (`docker compose ps -q`) do set DCPS=%%X
if ""%DCPS%%""=="""" (goto __LAUNCH__) else (goto __SHUTDOWN__)

:__LAUNCH__
echo Launch docker compose...
docker compose build
docker compose up -d
start http://localhost:3001
echo Launch Node-RED...
for %%a in ("%cur_path%") do set folder_name=%%~nxa
if exist NodeRED (
    cd NodeRED
    @echo.
    @echo. NodeREDを起動します
    start http://127.0.0.1:1880
    npm start
)
goto __END__

:__SHUTDOWN__
echo Shutdown...
docker compose down
@REM docker compose stop
goto __END__

:__END__