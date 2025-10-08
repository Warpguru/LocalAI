@ECHO OFF
START "Llama.cpp Gpt-OSS 20B" .\Llama.cpp\llama-server --model ".\Models\gpt-oss-20b\gpt-oss-20b-MXFP4.gguf" --host 0.0.0.0 --port 10000 --ctx-size 32768 --n-gpu-layers 40 --jinja
ECHO Please be patient for Llama.cpp to initialize ...
timeout 30
START http://127.0.0.1:10000
