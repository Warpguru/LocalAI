# Execute: powershell .\ICA_ListModels.ps1

$url = $env:ANTHROPIC_BASE_URL.TrimEnd('/') + '/v1/models'

curl.exe $url `
  -H "X-Api-Key: $env:ANTHROPIC_AUTH_TOKEN" |
  ConvertFrom-Json |
  ConvertTo-Json -Depth 100

