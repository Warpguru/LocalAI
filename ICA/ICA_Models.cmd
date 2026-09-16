@echo off
setlocal enabledelayedexpansion

:: Check if API key environment variable is set, otherwise prompt
if "%IBM_API_KEY%"=="" (
    set /p "IBM_API_KEY=Enter your API key: "
)

if "%IBM_API_KEY%"=="" (
    echo [ERROR] API key is required.
    exit /b 1
)

echo ========================================================
echo 1. Querying OpenAI Compatible API: https://api.servicesessentials.ibm.com/v1/models
echo ========================================================
curl -s -S -X GET "https://api.servicesessentials.ibm.com/v1/models" ^
  -H "Authorization: Bearer %IBM_API_KEY%" ^
  -H "Content-Type: application/json"

echo.
echo.
echo ========================================================
echo 2. Querying Anthropic API: https://api.servicesessentials.ibm.com/v1/models
echo ========================================================
curl -s -S -X GET "https://api.servicesessentials.ibm.com/v1/models" ^
  -H "x-api-key: %IBM_API_KEY%" ^
  -H "anthropic-version: 2023-06-01" ^
  -H "Content-Type: application/json"

echo.
echo.
echo Done.
endlocal
