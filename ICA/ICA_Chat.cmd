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
echo 1. Testing OpenAI Chat Completions (Model: gemini-3.6-flash)
echo    Endpoint: https://api.nextgen-beta.ica.ibm.com/ica/v1/chat/completions
echo ========================================================
curl -s -S -X POST "https://api.nextgen-beta.ica.ibm.com/ica/v1/chat/completions" ^
  -H "Authorization: Bearer %IBM_API_KEY%" ^
  -H "Content-Type: application/json" ^
  -d "{\"model\": \"gemini-3.6-flash\", \"messages\": [{\"role\": \"user\", \"content\": \"Why is the sky blue? Explain in one brief sentence.\"}]}"

echo.
echo.
echo ========================================================
echo 2. Testing Anthropic Messages (Model: claude-sonnet-5)
echo    Endpoint: https://api.nextgen-beta.ica.ibm.com/ica/v1/messages
echo ========================================================
curl -s -S -X POST "https://api.nextgen-beta.ica.ibm.com/ica/v1/messages" ^
  -H "x-api-key: %IBM_API_KEY%" ^
  -H "anthropic-version: 2023-06-01" ^
  -H "Content-Type: application/json" ^
  -d "{\"model\": \"claude-sonnet-5\", \"max_tokens\": 150, \"messages\": [{\"role\": \"user\", \"content\": \"Why is the sky blue? Explain in one brief sentence.\"}]}"

echo.
echo.
echo Done.
endlocal
