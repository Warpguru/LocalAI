@ECHO OFF
@setlocal enabledelayedexpansion

:: Check if ICA API key environment variable is set, otherwise prompt
:: See: https://nextgen-beta.ica.ibm.com/ica/settings/apikey
if "%IBM_API_KEY%"=="" (
    set /p "IBM_API_KEY=Enter your API key: "
)

if "%IBM_API_KEY%"=="" (
    echo [ERROR] ICA API key is required.
    exit /b 1
)

@START "LiteLLM" cmd /c ".\LiteLLM-Proxy\.venv\Scripts\litellm.exe --config ./config.yaml --debug --detailed_debug"
@endlocal