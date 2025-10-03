uv venv ClaudeProxy

uv pip install flask



Change Url

python3 ClaudeProxy.py



Test:
http://localhost:8000/health
http://localhost:8000/v1/models

curl -X POST http://localhost:8000/v1/messages -H "Content-Type: application/json" -d "{""model"":""claude-3-sonnet-20240229"",""messages"":\[{""role"":""user"",""content"":""Write a simple hello world function in Python""}]}"





PS1:  {'model': 'claude-3-sonnet-20240229','messages': \[{'role': 'user','content': 'Write a simple hello world function in Python'}]}

curl: {"model": "claude-3-sonnet-20240229","messages": \[{"role": "user","content": "Write a simple hello world function in Python"}]}



{'messages': \[{'content': 'Write a simple hello world function in Python', 'role': 'user'}], 'model': 'gpt-oss:20b', 'stream': False}



