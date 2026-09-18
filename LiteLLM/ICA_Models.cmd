@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo Querying OpenAI Compatible API
echo ========================================================
curl -s -S -X GET "http://localhost:4000/models" ^
  -H "Content-Type: application/json"

echo.
echo.
echo Done.
endlocal
