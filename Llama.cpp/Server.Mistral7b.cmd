@ECHO OFF
START "Llama.cpp Mistral 7B" .\Llama.cpp\llama-server --model ".\models/Mistral 7B Instruct v0.3\Mistral-7B-Instruct-v0.3-Q4_K_M.gguf" --port 10000 --ctx-size 32768 --n-gpu-layers 40 --jinja
ECHO Please be patient for Llama.cpp to initialize ...
timeout 30
START http://127.0.0.1:10000
