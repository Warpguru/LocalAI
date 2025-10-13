Postgres



https://www.enterprisedb.com/download-postgresql-binaries

postgresql-18.0-2-windows-x64-binaries.zip





SetupEnvPython.cmd



uv init LiteLLM-Proxy

cd LiteLLM-Proxy

uv sync

.venv\\scripts\\activate

uv add prisma

uv add litellm\[proxy]

prisma init

prisma generate



python -m prisma generate --schema D:\\LocalAI\\LiteLLM\\LiteLLM-Proxy\\.venv\\Lib\\site-packages\\litellm\\proxy\\schema.prisma

python -m prisma migrate deploy --schema D:\\LocalAI\\LiteLLM\\LiteLLM-Proxy\\.venv\\Lib\\site-packages\\litellm\\proxy\\schema.prisma





Not required? uv tool install litellm

-> D:\\LocalAI\\LiteLLM\\Users\\LiteLLM\\.local\\bin\\litellm.exe -> does not work

.venv\\Scripts\\litellm.exe -> works

python -m litellm -> does not work







SET LITELLM\_PROXY\_URL=http://localhost:4000

SET LITELLM\_PROXY\_API\_KEY=sk-1234

SET LITELLM\_MASTER\_KEY=sk-1234

SET LITELLM\_SALT\_KEY=sk-1234

SET DATABASE\_URL=postgres://postgres:trust@127.0.0.1:5432/litellm

SET PORT=4000

SET STORE\_MODEL\_IN\_DB=True







? litellm --config /app/config.yaml --detailed\_debug

