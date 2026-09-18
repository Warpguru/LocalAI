@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo 1. Testing OpenAI Chat Completions (Model: gpt-4o)
echo    Endpoint: http://localhost:4000/v1/chat/completions
echo ========================================================
curl -s -S -X POST "http://localhost:4000/v1/chat/completions" ^
  -H "Content-Type: application/json" ^
  -d "{\"model\": \"anthropic/gpt-4o\", \"messages\": [{\"role\": \"user\", \"content\": \"Why is the sky blue? Explain in one brief sentence.\"}]}"

echo.
echo.
echo Done.
endlocal
