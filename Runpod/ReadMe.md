# Pod configuration

**[Runpod](https://console.runpod.io/)** is a *Cloud GPU service* where you can, on demand, rent even very powerful **GPU**s. In contrast to **[Kaggle](https://www.kaggle.com/)**, which offers two 16GB T40 **GPU**s for free, there is no free option.

Powerful is not an exaggeration, because, at the time of writing, the most powerful **GPU** available is the **NVIDIA B300** with **288GB VRAM**. Assuming you can find a reseller, it will set you back about **$60,000**!
At a rate of **$8.99/hr**, renting is certainly an option even for experiments.

**Note!** The number of **GPU** types and their count varies, so you may not get the **GPU** of your choice at any time.

## Billing

**Runpod** is not a free service; however, compared with current GPU prices, you can easily run a pod for months.
Without any **[Billing](https://www.console.runpod.io/user/billing)** balance defined, you will not be able to run or even configure a pod because:

  * *Running* a pod will charge you.
  * A *Stopped* but not yet *Terminated* pod will also charge you (depending on the `Persistent storage` size defined for your pod).

**Hint!** You have to *Terminate* your pod to avoid incurring costs.

Use the **[Billing](https://www.console.runpod.io/user/billing)** page to add at least the minimum amount of `$10` to your balance.
Ensure that any option to automatically refund your account is deactivated (which it is at the time of writing).

---

## Configure a pod

Before you can run a **pod**, you have to [configure](https://www.console.runpod.io/pods) it:

1) Go to `https://console.runpod.io/` → `Pods`
2) Click `Deploy`
3) Click `Workload` → `Search templates`
4) From the `Select a template` dialog, search for `ollama/ollama:latest` (or your own template if you have created one)
5) Select `Set overrides` to ensure:
    * The `Volume mount path` is `/workspace`
    * Ports exposed are at least:
        - `11434` under `Exposed HTTP ports`
        - `22` under `Exposed TCP ports`
    * `Environment variables` (important so it listens externally and stores models on your volume):
        - `OLLAMA_HOST=0.0.0.0:11434`
        - `OLLAMA_MODELS=/workspace/models`
        - `OLLAMA_FLASH_ATTENTION=1` (optional)
6) Optionally change the `Pod name`
7) From `Compute`, select the **GPU** of your choice and/or **LLM** requirements, e.g.: `RTX A6000` (the LLM `hf.co/JonathanColetti/Qwen3.8-27B-Uncensored-GGUF:Q4_K_M` requires at least 24GB VRAM; with a large context window, 32GB is easily needed)
8) From `Storage`, select:
    * `Container disk` for the root filesystem, e.g.: `30GB`
    * `Persistent storage` for the `/workspace` filesystem the **LLM** will be downloaded into, e.g.: `40GB` for `hf.co/JonathanColetti/Qwen3.8-27B-Uncensored-GGUF:Q4_K_M`
        - Select `Volume disk` from the `Create storage` dialog
        - Adjust the volume `Size` to fit the **LLM** and **cache**
        - Ensure that it mounts to `/workspace`
        - Select `Add volume disk`
9) Click `Deploy Pod` (or `Deploy when available`)

Once it starts, Ollama will already be running because the Docker image’s default command starts the server.

### Why those settings matter

- `OLLAMA_HOST=0.0.0.0:11434` makes Ollama listen on all interfaces so **Runpod**’s proxy can reach it.
- Exposing `11434/http` is what gives you a browser/proxy URL you can call from home.
- Putting models in `/workspace/...` keeps them on your pod’s mounted storage rather than inside the container filesystem.

---

## Run pod

To [launch](https://www.console.runpod.io/pods) a pod, select it and click `Start for $x.xx/hr`.
As **GPU**s are limited resources, you might run into the error **Your Pod's GPUs are no longer available.**, which means you either can create a new pod (but remember that a stopped pod still incurs cost) or wait until a **GPU** becomes available (unfortunately, you cannot change the GPU in an existing pod).

### Pod control

Click on your [pod](https://console.runpod.io/pods) to open the pod details:
  * Connect:
    - Copy the exposed `HTTP services` port for **Ollama** and append `/v1`, e.g.: `https://htwnx1w74ie4gj-11434.proxy.runpod.net/v1`
    - Add your *private key* (see [SSH access](#ssh-access)) and copy the **SSH** login command from `SSH` (to configure **Putty** accordingly)
    - Select `Enable web terminal` to enable `Open web terminal`, which opens a shell to your pod in a new browser tab
  * Details:
    - Pod details
  * Volumes:
    - Utilization of the persistent storage volume `/workspace` (which is charged even if the pod is `Stopped`)
  * Telemetry:
    - Runtime telemetry data such as **CPU** and **GPU** utilization
  * Logs:
    - `Container` logs (e.g.: **Ollama** activity)
    - `System` logs
  * Template:
    - Pod template details
  * Console:
    - A shell into your pod

### Diagnostics

Check the amount of free space on the volume where you downloaded **LLM**s (the storage volume can be increased at any time, but not decreased):

```sh
du -sh /workspace/models
```

Display the **GPU** details:

```
nvidia smi
```

```
Thu Oct 15 14:17:33 2026
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 580.178.04             Driver Version: 580.178.04     CUDA Version: 13.0     |
+-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  NVIDIA RTX PRO 6000 Blac...    On  |   00000000:73:00.0 Off |                   On |
| N/A   53C    P0            275W /  600W |                  N/A   |     N/A      Default |
|                                         |                        |              Enabled |
+-----------------------------------------+------------------------+----------------------+

+-----------------------------------------------------------------------------------------+
| MIG devices:                                                                            |
+------------------+----------------------------------+-----------+-----------------------+
| GPU  GI  CI  MIG |              Shared Memory-Usage |        Vol|        Shared         |
|      ID  ID  Dev |                Shared BAR1-Usage | SM     Unc| CE ENC  DEC  OFA  JPG |
|                  |                                  |        ECC|                       |
|==================+==================================+===========+=======================|
|  0    6   0   0  |           17696MiB / 24192MiB    | 46      0 |  1   1    1    0    1 |
|                  |               0MiB /  8327MiB    |           |                       |
+------------------+----------------------------------+-----------+-----------------------+

+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|    0    6    0             4627      C   /usr/lib/ollama/llama-server          17624MiB |
+-----------------------------------------------------------------------------------------+
```

---

## SSH access

### Generate key

Use **PuttyGen** to generate a public/private key pair:
  * Select an `EdDSA` (Ed25519) type key
  * Click `Generate` to generate the key pair
  * Save the public key by clicking `Save public key`, e.g.: `Runpod.ppk`
  * Save the private key by clicking `Save private key`, e.g.: `Runpod.pub`
  * Copy the public key from `Public key for pasting into OpenSSH authorized_keys file` and paste it to your pod configuration

### Configure Putty

Configure **Putty** for e.g.: `Runpod`:
  * Set `ssh.runpod.io` as the `Host Name`
  * Under `Connection` → `Data`, copy the username shown by **Runpod** into `Auto-login username`
  * Under `Connection` → `SSH` → `Auth` → `Credentials`, set the fully qualified filename, e.g.: `x:\path\Runpod.ppk`, into `Private key file for authentication`
  * `Save` the SSH configuration for accessing your pod as e.g.: `Runpod`
