# Execute: powershell .\ICA_ListModels.ps1

curl.exe https://api.nextgen-beta.ica.ibm.com/ica/v1/models `
  -H "X-Api-Key: $env:ANTHROPIC_AUTH_TOKEN" |
  ConvertFrom-Json |
  ConvertTo-Json -Depth 100
