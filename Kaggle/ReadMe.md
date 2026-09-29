# Kaggle

[Kaggle](https://www.kaggle.com) is a platform for developing with **Jupyter** notebooks. Its hosted virtual machines provide storage, CPU resources, and access to relatively powerful **NVIDIA GPUs**.

## Summary

This guide shows how to use Kaggle's hosted GPUs as a temporary test bench for open-weight LLMs. The setup described here uses two **NVIDIA T4 GPUs** with **16 GB of VRAM each** (32 GB combined, not a single shared 32 GB pool). This offers a way to experiment with that much GPU memory without buying comparable local hardware, which can be prohibitively expensive amid current memory prices. With a notebook, **Ollama**, and an optional tunnel, you can run models that may not fit on your own hardware and connect them to API-compatible development tools such as **Cline** or **OpenCode**, without first provisioning a GPU server. The guide covers model formats and quantization, the realities of multi-GPU inference, and observed performance, helping you decide whether self-hosting is practical for your needs.

Kaggle access, GPU availability, and usage limits can change, and notebook sessions are temporary. The benchmark reflects general prompts on this specific setup; it is not a measure of coding ability. Public tunnels are unauthenticated, so use them only for temporary experiments and never expose sensitive data.

---

## Registration

Registering for **[Kaggle](https://www.kaggle.com)** provides limited, free access to **NVIDIA GPUs**, which can be used to run **LLMs**, for example.

### Kaggle

* Register at [Kaggle](https://www.kaggle.com), for example with your **Google account**.
* After signing in, open your profile, go to `Settings`, and select `Phone verification` to verify your phone number. After you enter the verification code, GPU accelerators may become available. Availability, GPU models, and weekly usage limits are subject to change; at the time of writing, Kaggle offered two **NVIDIA T4 GPUs** with **16 GB of VRAM** for up to 30 hours per week.
* Create a `Collection`, for example `AI`.
* Create a Jupyter `Notebook` and add it to the collection.
* To enable **GPU** support for the notebook, select `Settings`→`Accelerator`→`GPU T4 x2`.
* To configure notebook secrets, such as an **ngrok** API key, select `Add-ons`→`Secrets`→`Add Secret`. **Kaggle** shows how to retrieve a secret:
```python
from kaggle_secrets import UserSecretsClient
user_secrets = UserSecretsClient()
secret_value_0 = user_secrets.get_secret("LLM_MODEL")
secret_value_1 = user_secrets.get_secret("NGROK_TOKEN")
```

### Hugging Face

[Hugging Face](https://huggingface.co/) hosts a large collection of **LLMs**, including models that can be used with **Kaggle**.

* Register at [Hugging Face](https://huggingface.co/).
* Sign in, open `Models`, and select a model or search for one, for example `JonathanColetti/Qwen3.8-27B-Uncensored-GGUF`.
* Select `Hardware compatibility` and enter two NVIDIA T4 GPUs with 16 GB of VRAM each so **Hugging Face** can identify compatible models.
* Select one of the quantizations compatible with that hardware.
* In the selected quantization's properties panel, click `Use this model` to copy the full model name or select `Kaggle` to open a Jupyter notebook containing example code.

---

## Important considerations

### Model formats

**Hugging Face** repositories do not necessarily provide every model in every format. Common formats include **Safetensors**, **GPTQ**, **AWQ**, and **GGUF**, and each format requires compatible inference software. For this **Ollama** workflow, choose a **GGUF** model. Ollama can download and run models from its registry, or import a compatible GGUF file; a Safetensors, GPTQ, or AWQ file cannot be used directly as a GGUF model. Also make sure that the selected quantization fits the available VRAM.

The model `hf.co/unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF:Q4_K_M` is a **Mixture-of-Experts (MoE)** model. Instead of using all of its neural-network parameters for every token, a router selects a subset of specialised experts for each token. In the `30B-A3B` name, `30B` refers approximately to the model's total parameter count, while `A3B` indicates that approximately 3 billion parameters are active for each token. This can reduce computation and improve generation speed compared with a dense 30B model, but the complete set of expert weights still has to be stored and loaded. Consequently, an MoE model may require VRAM and disk space closer to a 30B model than to a 3B model. The actual memory use and speed also depend on the quantization, context length, runtime, and number of experts selected per token.

### Quantization

Quantization stores model weights with fewer bits. `FP16` uses 16 bits per weight and generally preserves model quality well, but it requires substantial memory. 8-bit and 4-bit formats reduce memory use and often make much larger models fit on the available GPUs. The trade-offs are lower numerical precision, possible quality loss, and format-dependent changes in performance. Extremely low-bit formats, such as 1-bit or 2-bit formats, save even more memory but can noticeably reduce output quality and are not supported equally well by every inference engine. Quantization does not reduce the **KV cache** or all other runtime memory, so the model weights are only part of the total **VRAM** requirement.

### NVIDIA T4 limitations

The **NVIDIA T4** is a capable and efficient inference accelerator, but it is not a current high-end GPU. It has **16 GB** of VRAM, lower memory bandwidth than newer data-centre GPUs, and no support for some newer acceleration features. Generation speed therefore depends on the model, quantization, context length, and inference engine. The benchmark below is specific to this Kaggle setup and should not be treated as a general comparison between models.

### Using multiple GPUs

Two GPUs do not automatically provide the same performance as one GPU with twice the VRAM. A model split across GPUs must exchange intermediate data between them. The available interconnect, transfer size, synchronization, and software support all affect the result. **PCIe** is usually a significant bottleneck; even a fast network such as **400 Gbit/s Ethernet** or **Thunderbolt 5** adds latency and protocol overhead. **NVLink** can improve communication on supported hardware, but it still does not turn multiple GPUs into one uniform memory pool. Multi-GPU inference is therefore more complex and may be slower than expected, especially for smaller models.

### Public tunnels

The **NGgrok** and **Cloudflare** examples publish the local Ollama API without authentication. Anyone who obtains the public URL may be able to submit requests and consume the available resources. Use these tunnels only for temporary experiments, never expose sensitive data, and add an authenticated proxy before using a public endpoint for anything important.

---

## Benchmark

The following data was collected during sessions on **Kaggle**.

### Qwen 3.8 27B (`hf.co/unsloth/Qwen3.8-27B-GGUF:UD-Q4_K_M`)

```
Summary
-------------------------------------------------------------
Why is the sky blue?        39.6 s    524 tokens    13.49 TPS
Why is grass green?         37.7 s    487 tokens    13.15 TPS
Why is water wet?           58.5 s    760 tokens    13.15 TPS
-------------------------------------------------------------
Average time : 45.3 s
Average TPS  : 13.26
```

### Qwen 3.8 27B (`hf.co/JonathanColetti/Qwen3.8-27B-Uncensored-GGUF:Q4_K_M`)

```
Summary
-------------------------------------------------------------
Why is the sky blue?        50.3 s    601 tokens    12.16 TPS
Why is grass green?         25.8 s    310 tokens    12.37 TPS
Why is water wet?           46.5 s    563 tokens    12.29 TPS
-------------------------------------------------------------
Average time : 40.9 s
Average TPS  : 12.27
```

### Qwen 3.8 9B (`hf.co/mradermacher/Qwen3.8-9B-heretic-uncensored-GGUF:Q4_K_M`)

```
Summary
-------------------------------------------------------------
Why is the sky blue?        11.7 s    323 tokens    28.13 TPS
Why is grass green?         11.4 s    297 tokens    26.42 TPS
Why is water wet?           18.1 s    441 tokens    24.60 TPS
-------------------------------------------------------------
Average time : 13.7 s
Average TPS  : 26.38
```

### Granite 4.2 30B (`hf.co/ibm-granite/granite-4.2-30b-GGUF:Q4_K_M`)

```
Summary
-------------------------------------------------------------
Why is the sky blue?        23.4 s    293 tokens    12.75 TPS
Why is grass green?         23.8 s    299 tokens    12.70 TPS
Why is water wet?           56.8 s    706 tokens    12.49 TPS
-------------------------------------------------------------
Average time : 34.7 s
Average TPS  : 12.65
```

### Deepseek R1 (`hf.co/unsloth/DeepSeek-R1-Distill-Qwen-32B-GGUF:Q4_K_M`)

```
Summary
-------------------------------------------------------------
Why is the sky blue?        91.1 s    829 tokens     9.15 TPS
Why is grass green?        107.8 s    953 tokens     8.88 TPS
Why is water wet?          100.4 s    887 tokens     8.88 TPS
-------------------------------------------------------------
Average time : 99.8 s
Average TPS  : 8.97
```

### Qwen3 Coder 30B (`hf.co/unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF:Q4_K_M`)

```
Summary
-------------------------------------------------------------
Why is the sky blue?         4.4 s    248 tokens    57.86 TPS
Why is grass green?          3.6 s    231 tokens    64.86 TPS
Why is water wet?            4.5 s    286 tokens    64.30 TPS
-------------------------------------------------------------
Average time : 4.2 s
Average TPS  : 62.34
```

---

## Getting started

For a comprehensive developer agent ecosystem like **Cline** or **OpenCode**, the clear winner among the models you tested is the `unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF:Q4_K_M`.
When building complex agentic pipelines—which involve continuous multi-file exploration, executing terminal commands, evaluating code diffs, and self-debugging—your primary bottlenecks are tool-calling logic, context retention, and token generation speed.
A direct comparison highlights how these models stack up for agentic development tasks:

### Comparison for Agentic Development (Cline / OpenCode)

| Model Name | Coding/Logic Quality | Speed (TPS) on 2x T4 | Tool & MCP Reliability | Multi-File Context Capacity |
|---|---|---|---|---|
| Qwen3 Coder 30B (A3B) | Elite (Tuned for Repos) | High (~25-35 TPS via MoE) | Excellent (Native JSON/Tools) | Outstanding (Up to 256k native) |
| DeepSeek-R1-Distill 32B | Elite (Deep Reasoning) | Low (~8-10 TPS) | Moderate (Thinking loops can break parser) | Good |
| Qwen 3.8 27B (Standard/Uncensored) | Great (General) | Low (~10 TPS) | Good | Good |
| Granite 4.2 30B | Great (Enterprise Coding) | Low (~9-11 TPS) | Good | Good |
| Qwen 3.8 9B (Heretic) | Moderate | Very High (~40+ TPS) | Poor (Frequent syntax/JSON breaks) | Limited |

### Why Qwen3 Coder 30B (A3B) is the Best Choice

   1. The MoE Speed Advantage over Cloudflare:<br/>
    Because Cline works in loops (e.g., Read File→Search Code→Run Terminal Test→Edit Code), a standard dense model like the 27B or Granite 30B can take 20–30 seconds per loop in this setup, with PCIe transfers adding overhead. The Qwen3 Coder MoE only activates 3.3B parameters per token. This keeps the Cloudflare API response snappy, allowing the agent to execute actions rapidly.
   2. Native Tool and MCP Support:<br/>
   Cline relies heavily on structured JSON formats to execute actions like write_to_file or execute_command. While DeepSeek-R1-32B has superior raw mathematical logic, its long internal <think> loops often confuse the strict output parsers of tools like Cline, leading to execution errors. Qwen3 Coder is explicitly trained to output precise tool arguments.
   3. Massive Context Windows for Large Codebases:<br/>
    The A3B variant handles long context lengths efficiently. As Cline pulls in system logs, file structures, and source files, a smaller model like the Qwen 9B may reach its configured context limit sooner. The 30B MoE can handle these large payloads with minimal degradation, depending on the context settings and available VRAM.

### The Runner-Up Option

* Keep DeepSeek-R1-Distill-Qwen-32B as your secondary option. It is ideal for complex algorithmic challenges, writing intricate regex, or diagnosing obscure runtime errors. You can manually switch to it when Cline needs deep architectural reasoning rather than rapid file modifications.

Are you running into any JSON parsing errors or context limits in Cline/OpenCode with your current model setup, or would you like assistance optimizing the Ollama system parameters (like num_ctx or temperature) specifically for the Qwen3 Coder model?

---

## Jupyter notebook

The example below shows how to use a Jupyter `Notebook` to serve an LLM that requires approximately 24 GB of VRAM. The model runs locally on **Kaggle** and is made available over the internet through either **ngrok** (which requires an API key stored in the `NGROK_TOKEN` secret) or **Cloudflare** (which requires no account credentials and assigns a random URL, such as `https://gates-boss-matthew-heaven.trycloudflare.com/v1`). Read the security warning above before using either option.

Create an empty **Jupyter** notebook, then switch to `Script` mode by selecting `File`→`Editor Type`→`Script`. Paste the **Python** script into the editor, then switch back to `Notebook` view by selecting `File`→`Editor Type`→`Notebook`.

Before running the notebook, add a Kaggle secret named `LLM_MODEL` and set its value to a model identifier, such as one of the models tested in the [Benchmark](#benchmark) chapter.

```python
# %% [markdown] {"jupyter":{"outputs_hidden":false}}
# # Install **Ollama**

# %% [code] {"jupyter":{"outputs_hidden":false}}
!sudo apt-get install zstd
!curl -fsSL https://ollama.com/install.sh | sh

# %% [markdown] {"jupyter":{"outputs_hidden":false}}
# # Install **NGrok** to publish Kaggle local **Ollama** instance on Internet
# Install NGrok (alternatively use Cloudflare)

# %% [code] {"jupyter":{"outputs_hidden":false}}
!wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
!tar -xzf ngrok-v3-stable-linux-amd64.tgz
!./ngrok --version

# %% [markdown] {"jupyter":{"outputs_hidden":false}}
# # Install **Cloudflare** to publish Kaggle local **Ollama** on Internet
# Install Cloudflare (alternatively use NGrok)

# %% [code] {"jupyter":{"outputs_hidden":false}}
!wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
!dpkg -i cloudflared-linux-amd64.deb
!cloudflared --version

# %% [markdown] {"jupyter":{"outputs_hidden":false}}
# # Start **Ollama** as a subprocess

# %% [code] {"jupyter":{"outputs_hidden":false}}
import subprocess
import time
import os

env = os.environ.copy()
env["OLLAMA_HOST"] = "0.0.0.0:11434"
env["OLLAMA_ORIGINS"] = "*"
logfile = open("/tmp/ollama.log", "w")

proc = subprocess.Popen(
    ["ollama", "serve"],
    env=env,
    stdout=logfile,
    stderr=subprocess.STDOUT,
)

time.sleep(5)
if proc.poll() is None:
    print("✅ Ollama running with PID", proc.pid)
else:
    print("❌ Ollama exited unexpectedly")
    with open("/tmp/ollama.log") as f:
        print(f.read())

# %% [markdown] {"jupyter":{"outputs_hidden":false}}
# ## Check **Ollama** instance is running on Kaggle locally

# %% [code] {"jupyter":{"outputs_hidden":false}}
!ollama --version

# %% [markdown] {"jupyter":{"outputs_hidden":false}}
# # Download **LLM** to be served by **Ollama**

# %% [code] {"jupyter":{"outputs_hidden":false}}
from kaggle_secrets import UserSecretsClient
import subprocess

user_secrets = UserSecretsClient()
model = user_secrets.get_secret("LLM_MODEL")

print(f"Downloading {model}, this may take minutes ...")
result = subprocess.run(
    ["ollama", "pull", model],
    capture_output=True,
    text=True,
)
if result.returncode == 0:
    print("✅ Model downloaded successfully")
else:
    print("❌ Download failed")
    print(result.stdout)
    print(result.stderr)

# %% [markdown] {"jupyter":{"outputs_hidden":false}}
# # List downloaded **LLM**s

# %% [code] {"jupyter":{"outputs_hidden":false}}
!ollama list

# %% [markdown] {"jupyter":{"outputs_hidden":false}}
# # Publish Kaggle local **Ollama** on Internet with **NGrok**
# Requires your **secret token** (add via *Add-ons*→*Secrets*→*Add Secret* under the key *NGROK_TOKEN*)<br>
# Alternatively publish with Cloudflare

# %% [code] {"jupyter":{"outputs_hidden":false}}
# Publish local Ollama to Internet via NGrok
from kaggle_secrets import UserSecretsClient
import subprocess
import time
import requests

client = UserSecretsClient()
ngrok_token = client.get_secret("NGROK_TOKEN")

# Configure token
subprocess.run(
    ["./ngrok", "config", "add-authtoken", ngrok_token],
    capture_output=True,
    text=True
)

# Start ngrok
ngrok_proc = subprocess.Popen(
    ["./ngrok", "http", "11434"],
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,
    text=True
)

time.sleep(10)

# Did the local API come up?
try:
    r = requests.get(
        "http://127.0.0.1:4040/api/tunnels",
        timeout=2
    )
    
    data = r.json()
    public_url = data["tunnels"][0]["public_url"]
    print()
    print("✅ OpenAI-compatible API served at:")
    print(f"{public_url}/v1")
    print()
    
    print("Examples:")
    print(f"  Chat Completions : {public_url}/v1/chat/completions")
    print(f"  Models           : {public_url}/v1/models")
    print(f"  Ollama Chat      : {public_url}/api/chat")
    print(f"  Ollama Tags      : {public_url}/api/tags")

except Exception as e:
    print("Could not obtain ngrok URL")
    print("Exception:", e)
    # Read ngrok output
    if ngrok_proc.poll() is not None:
        print("\nngrok exited with code", ngrok_proc.returncode)
    print("\nngrok log:")
    if ngrok_proc.stdout:
        print(ngrok_proc.stdout.read())

# %% [markdown] {"jupyter":{"outputs_hidden":false}}
# # Publish Kaggle local **Ollama** with **Cloudflare**
# Alternatively publish with NGrok

# %% [code] {"jupyter":{"outputs_hidden":false}}
# Publish local Ollama to Internet via Cloudflare
import subprocess
import select
import time
import re
import requests

cloudflared = subprocess.Popen(
    [
        "cloudflared",
        "tunnel",
        "--url", "http://127.0.0.1:11434",
        "--http-host-header", "localhost:11434",
    ],
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,
    text=True,
    bufsize=1,
)

logs = []
public_url = None
startup_deadline = time.time() + 30
while time.time() < startup_deadline:
    ready, _, _ = select.select([cloudflared.stdout], [], [], 0.5)
    if not ready:
        continue
    line = cloudflared.stdout.readline()
    if not line:
        continue
    logs.append(line)
    m = re.search(r"https://[a-zA-Z0-9.-]+\.trycloudflare\.com", line, )
    if m:
        public_url = m.group(0)
        break
if public_url:
    reachable = False
    last_status = None
    last_body = None
    last_error = None
    for _ in range(20):
        try:
            r = requests.get(f"{public_url}/api/tags", timeout=10, )
            last_status = r.status_code
            last_body = r.text[:1000]
            if r.status_code == 200:
                reachable = True
                break
        except Exception as e:
            last_error = str(e)
        time.sleep(1)
    if reachable:
        print("✅ OpenAI-compatible API served at:")
        print(f"{public_url}/v1")
        print()

        print("Examples:")
        print(f"  Chat Completions : {public_url}/v1/chat/completions")
        print(f"  Models           : {public_url}/v1/models")
        print(f"  Ollama Chat      : {public_url}/api/chat")
        print(f"  Ollama Tags      : {public_url}/api/tags")
    else:
        print("❌ Cloudflare tunnel was created but is not reachable.\n")
        if last_status is not None:
            print(f"Last HTTP status: {last_status}\n")

# %% [markdown] {"jupyter":{"outputs_hidden":false}}
# ## Optional sample chat

# %% [code] {"jupyter":{"outputs_hidden":false}}
# Optional chat example
from kaggle_secrets import UserSecretsClient
import requests
import time

user_secrets = UserSecretsClient()
model = user_secrets.get_secret("LLM_MODEL")
print(f"Model: {model}\n")

start = time.time()
response = requests.post(
    "http://localhost:11434/api/chat",
    json={
        "model": model,
        "messages": [
            {"role": "user", "content": "Summarize the Tiananmen Square protests and massacre of 1989."}
        ],
        "stream": False,
        "think": False
    }
)
elapsed = time.time() - start
result = response.json()
eval_count = result.get("eval_count", 0)
eval_duration_ns = result.get("eval_duration", 0)
tps = (
    eval_count / (eval_duration_ns / 1e9)
    if eval_duration_ns > 0
    else 0
    )

#print(result["load_duration"])
#print(result["eval_duration"])
print(result)
print()
print(f"  Time      : {elapsed:.1f} s")
print(f"  Tokens    : {eval_count}")
print(f"  TPS       : {tps:.2f}")
print()

# %% [markdown] {"jupyter":{"outputs_hidden":false}}
# ## Sample benchmark

# %% [code] {"jupyter":{"outputs_hidden":false}}
# Optional benchmark Kaggle GPUs
from kaggle_secrets import UserSecretsClient
import requests
import time

user_secrets = UserSecretsClient()
model = user_secrets.get_secret("LLM_MODEL")
print(f"Model: {model}\n")

questions = [
    "Why is the sky blue?",
    "Why is grass green?",
    "Why is water wet?"
]
results = []

for question in questions:
    start = time.time()
    response = requests.post(
        "http://localhost:11434/api/chat",
        json={
            "model": model,
            "messages": [
                {
                    "role": "user",
                    "content": question
                }
            ],
            "stream": False,
            "think": False
        }
    )
    elapsed = time.time() - start
    result = response.json()
    eval_count = result.get("eval_count", 0)
    eval_duration_ns = result.get("eval_duration", 0)
    tps = (
        eval_count / (eval_duration_ns / 1e9)
        if eval_duration_ns > 0
        else 0
    )
    results.append({
        "question": question,
        "elapsed": elapsed,
        "tokens": eval_count,
        "tps": tps
    })
    print(f"{question}")
    print(f"  Time      : {elapsed:.1f} s")
    print(f"  Tokens    : {eval_count}")
    print(f"  TPS       : {tps:.2f}")
    print()
print("\nSummary")
print("-" * 80)
avg_tps = sum(r["tps"] for r in results) / len(results)
avg_time = sum(r["elapsed"] for r in results) / len(results)
for r in results:
    print(
        f"{r['question']:<25}"
        f" {r['elapsed']:>6.1f} ss"
        f" {r['tokens']:>6} tokenss"
        f" {r['tps']:>8.2f} TPSS"
    )
print("-" * 80)
print(f"Average time : {avg_time:.1f} s")
print(f"Average TPS  : {avg_tps:.2f}")

# %% [markdown] {"jupyter":{"outputs_hidden":false}}
# ## Check if **Ollama** is (still) alive
# (Re)start Ollama when required

# %% [code] {"jupyter":{"outputs_hidden":false}}
# Check if Ollama is alive
import requests

try:
    r = requests.get("http://127.0.0.1:11434/api/tags", timeout=5, )
    print("✅ Ollama reachable:", r.status_code)
except Exception as e:
    print("❌ Ollama not running:", e)
```
