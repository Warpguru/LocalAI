$body = @{
    model = "claude-3-sonnet-20240229"
    messages = @(
        @{
            role = "user"
            content = "Write a simple hello world function in Python"
        }
    )
} | ConvertTo-Json -Depth 3

Invoke-RestMethod -Uri "http://localhost:8000/v1/messages" -Method POST -Body $body -ContentType "application/json"
