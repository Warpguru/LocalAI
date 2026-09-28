# Kaggle

[Kaggle](https://www.kaggle.com) is a platform that supports development using **Jupyter** notebooks, but its virtual machine in addition to storage and CPU also supports access to **NVidia GPU**s.

## Registration

A registration at **[Kaggle](https://www.kaggle.com)** provides you (limited) use of powerful **NVidia GPU**s free of charge to e.g. run **LLM**s.

### Kaggle

* Register yourself at [Kaggle](https://www.kaggle.com) e.g. with you **Google account**
* Once registered and logged in, click on your profile, open the `Settings` page and select `Phone verification` to register your phone number. After receiving and entering a TAN code the option to select a GPU (at the time of writing **2 NVidia T4 GPU**s with **16GB VRAM** will be available for free up to 30 hours a week.
* Create a `Collection` e.g. `AI`
* Create a Jupyter `Notebook` and add it to your collection
* To enable **GPU** support for that notebook select `Settings`→`Accelerator`→`GPU T4 x2`
* To enable specific configuration settings for your notebook such as e.g. an **NGrok** API-key select `Add-ons`→`Secrets`→`Add Secret` to add its key value pair. **Kaggle** will show how to retrieve that setting:
     > from kaggle_secrets import UserSecretsClient
user_secrets = UserSecretsClient()
secret_value_0 = user_secrets.get_secret("LLM_MODEL")
secret_value_1 = user_secrets.get_secret("NGROK_TOKEN") 

### HuggingFace

[HuggingFace](https://huggingface.co/), recently got part of **NVidia**, features a large collection of **LLM**s that can be used with **Kaggle**.

* Register youself at [HuggingFace](https://huggingface.co/)
* Login and select `Models` and select a model or search for a model e.g. `JonathanColetti/Qwen3.8-27B-Uncensored-GGUF`
* Select `Hardware compatibility` to add 2 NVidia T4 GPUs with 16GB VRAM each so **HuggingFace** marks the LLMs compatible with that hardware
* Click on one of the quantizations compatible with the selected hardware
* From the properties panel of the selected quantization click on `Use this model` to either copy the full name of the model or click on `Kaggle` to get a Jupyter notebook with code to use that model  

## Example

The following example is a Jupyter `Notebook` that serves a LLM that typically required about 24GB of VRAM.
The LLM running locally at **Kaggle** is then served on the Internet by either **NGrok** (for which you have to provide an API key for the `NGROK_TOKEN` secret key) or **Cloudflare** (which has no prerequisites and serves a random url such as `https://gates-boss-matthew-heaven.trycloudflare.com/v1`).

```Python
# %% [markdown] {"jupyter":{"outputs_hidden":false}}
# # Install **Ollama**

# %% [code] {"execution":{"iopub.status.busy":"2026-09-28T14:10:46.255052Z","iopub.execute_input":"2026-09-28T14:10:46.255837Z","iopub.status.idle":"2026-09-28T14:11:16.641550Z","shell.execute_reply.started":"2026-09-28T14:10:46.255803Z","shell.execute_reply":"2026-09-28T14:11:16.640673Z"},"jupyter":{"outputs_hidden":false}}
!sudo apt-get install zstd
!curl -fsSL https://ollama.com/install.sh | sh

# %% [markdown] {"jupyter":{"outputs_hidden":false}}
# # Install **NGrok** to publish Kaggle local **Ollama** instance on Internet
# Install NGrok (alternatively use Cloudflare)

# %% [code] {"execution":{"iopub.status.busy":"2026-09-28T12:31:48.212179Z","iopub.execute_input":"2026-09-28T12:31:48.212456Z","iopub.status.idle":"2026-09-28T12:31:49.646518Z","shell.execute_reply.started":"2026-09-28T12:31:48.212426Z","shell.execute_reply":"2026-09-28T12:31:49.645331Z"},"jupyter":{"outputs_hidden":false}}
!wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
!tar -xzf ngrok-v3-stable-linux-amd64.tgz
!./ngrok --version

# %% [markdown] {"jupyter":{"outputs_hidden":false}}
# # Install **Cloudflare** to publish Kaggle local **Ollama** on Internet
# Install Cloudflare (alternatively use NGrok)

# %% [code] {"execution":{"iopub.status.busy":"2026-09-28T14:11:16.643646Z","iopub.execute_input":"2026-09-28T14:11:16.643902Z","iopub.status.idle":"2026-09-28T14:11:18.972061Z","shell.execute_reply.started":"2026-09-28T14:11:16.643874Z","shell.execute_reply":"2026-09-28T14:11:18.971394Z"},"jupyter":{"outputs_hidden":false}}
!wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
!dpkg -i cloudflared-linux-amd64.deb
!cloudflared --version

# %% [markdown] {"jupyter":{"outputs_hidden":false}}
# # Start **Ollama** as a subprocess

# %% [code] {"execution":{"iopub.status.busy":"2026-09-28T14:11:23.228858Z","iopub.execute_input":"2026-09-28T14:11:23.229149Z","iopub.status.idle":"2026-09-28T14:11:28.238269Z","shell.execute_reply.started":"2026-09-28T14:11:23.229122Z","shell.execute_reply":"2026-09-28T14:11:28.237408Z"},"jupyter":{"outputs_hidden":false}}
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

# %% [code] {"execution":{"iopub.status.busy":"2026-09-28T14:11:31.662886Z","iopub.execute_input":"2026-09-28T14:11:31.663473Z","iopub.status.idle":"2026-09-28T14:11:36.805896Z","shell.execute_reply.started":"2026-09-28T14:11:31.663443Z","shell.execute_reply":"2026-09-28T14:11:36.805179Z"},"jupyter":{"outputs_hidden":false}}
!ollama --version

# %% [markdown] {"jupyter":{"outputs_hidden":false}}
# # Download **LLM** to be served by **Ollama**

# %% [code] {"execution":{"iopub.status.busy":"2026-09-28T14:11:39.240382Z","iopub.execute_input":"2026-09-28T14:11:39.240852Z","iopub.status.idle":"2026-09-28T14:15:10.340382Z","shell.execute_reply.started":"2026-09-28T14:11:39.240812Z","shell.execute_reply":"2026-09-28T14:15:10.339677Z"},"jupyter":{"outputs_hidden":false}}
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

# %% [code] {"execution":{"iopub.status.busy":"2026-09-28T14:15:59.956381Z","iopub.execute_input":"2026-09-28T14:15:59.956801Z","iopub.status.idle":"2026-09-28T14:16:05.207674Z","shell.execute_reply.started":"2026-09-28T14:15:59.956771Z","shell.execute_reply":"2026-09-28T14:16:05.206954Z"},"jupyter":{"outputs_hidden":false}}
!ollama list

# %% [markdown] {"jupyter":{"outputs_hidden":false}}
# # Publish Kaggle local **Ollama** on Internet with **NGrok**
# Requires your **secret token** (add via *Add-ons*->*Secrets*->*Add Secret* under the key *NGROK_TOKEN*)<br>
# Alternatively publish with Cloudflare

# %% [code] {"jupyter":{"outputs_hidden":false},"execution":{"iopub.status.busy":"2026-09-28T11:23:20.175083Z","iopub.execute_input":"2026-09-28T11:23:20.175862Z","iopub.status.idle":"2026-09-28T11:23:20.525981Z","shell.execute_reply.started":"2026-09-28T11:23:20.175797Z","shell.execute_reply":"2026-09-28T11:23:20.524809Z"}}
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

# %% [code] {"execution":{"iopub.status.busy":"2026-09-28T14:16:11.972769Z","iopub.execute_input":"2026-09-28T14:16:11.973214Z","iopub.status.idle":"2026-09-28T14:16:33.613775Z","shell.execute_reply.started":"2026-09-28T14:16:11.973181Z","shell.execute_reply":"2026-09-28T14:16:33.613052Z"},"jupyter":{"outputs_hidden":false}}
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

# %% [code] {"execution":{"iopub.status.busy":"2026-09-28T09:45:38.055991Z","iopub.execute_input":"2026-09-28T09:45:38.056440Z","iopub.status.idle":"2026-09-28T09:47:17.732949Z","shell.execute_reply.started":"2026-09-28T09:45:38.056409Z","shell.execute_reply":"2026-09-28T09:47:17.732205Z"},"jupyter":{"outputs_hidden":false}}
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

# %% [code] {"execution":{"iopub.status.busy":"2026-09-28T09:21:07.777795Z","iopub.execute_input":"2026-09-28T09:21:07.778286Z","iopub.status.idle":"2026-09-28T09:23:03.607495Z","shell.execute_reply.started":"2026-09-28T09:21:07.778256Z","shell.execute_reply":"2026-09-28T09:23:03.606703Z"},"jupyter":{"outputs_hidden":false}}
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

# %% [code] {"execution":{"iopub.status.busy":"2026-09-28T14:23:54.588283Z","iopub.execute_input":"2026-09-28T14:23:54.588678Z","iopub.status.idle":"2026-09-28T14:23:54.599094Z","shell.execute_reply.started":"2026-09-28T14:23:54.588634Z","shell.execute_reply":"2026-09-28T14:23:54.598435Z"},"jupyter":{"outputs_hidden":false}}
# Check if Ollama is alive
import requests

try:
    r = requests.get("http://127.0.0.1:11434/api/tags", timeout=5, )
    print("✅ Ollama reachable:", r.status_code)
except Exception as e:
    print("❌ Ollama not running:", e)
```

