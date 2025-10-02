# LocalAI

## Abstract

This project contains a template directory structure to run LLMs locally (**OpenAI API** compatible servers and clients).

## Model formats

**LLM** consist of tensors and metadata stored in binary files designed for fast loading and inference on consumer-grade hardware.
There are at least 2 popular file formats:

  - Ollama: A **LLM** is stored in multiple **BLOB** (binary large object) files, including 1 file containing the <b>*Modelfile*</b>.
  This file format is used by **[Ollama](https://ollama.com/)**
  - GGUF: A **LLM** in **GGUF** (GPT-Generated Unified Format) is a single binary file that also includes the <b>*chat_template*</b>.
  The **GGUF** format is popular because of **[HuggingFace](https://huggingface.co/)**, a major hub of the **AI** community.
  This file format is used by **[LM Studio](https://lmstudio.ai/)** and **[Llama.cpp](https://github.com/ggml-org/llama.cpp)**.
 
This is important as the file formats are not easily interchangeable between different tools.
And as **LLM**s are quit large downloads one should think first which tool will be used and which file format is required.
One issue to consider is, the **GGUF** file format seems to be more widely used, so the tool support for new **LLM**s is
likely earlier available as for the **Ollama** file format.

**Hint!** You can share **LLM**s between different tools without downloading the same **LLM** multiple time by using symbolic links.
Just symlink the downloaded **GGUF** file from one path to another path, e.g. assuming a download of **Gpg-Oss-20B** with **[LM Studio](https://lmstudio.ai/models/openai/gpt-oss-20b)** into file <b>*D:\LocalAI\LMStudio\Users\.lmstudio\models\lmstudio-community\gpt-oss-20b-GGUF\gpt-oss-20b-MXFP4.gguf*</b> use it with **Llama.cpp** from the file <b>*D:\LocalAI\Llama.cpp\Models\gpt-oss-20b\gpt-oss-20b-MXFP4.gguf*</b> by:

```
mklink D:\LocalAI\Llama.cpp\Models\gpt-oss-20b\gpt-oss-20b-MXFP4.gguf D:\LocalAI\LMStudio\Users\.lmstudio\models\lmstudio-community\gpt-oss-20b-GGUF\gpt-oss-20b-MXFP4.gguf
```

### Conversion

An example how to convert a **LLM** in **GGUF** file format is shown in the **[Ollama](../Ollama/Ollama/ReadMe.md)** chapter.

## Processing

A few words on how a <b>*user message*</b> such as e.g. <b>*Why is the sky blue?*</b> gets processed to an answer such as e.g. <b>*Because of Rayleigh scattering.*</b>.
This is important to understand how a **LLM** represents the input internally to process it, especially in conjunction with a **Modelfile** or **chat_template** as they may contain a default <b>*system message*</b> such as <b>*You are a helpful assistant!*</b>. 

![Message processing](.\doc\LLM.png "Message Processing")

The <b>*user message*</b>, which may be multi-media not just text, is sent to the **LLM**:

1. The user enters the <b>*user message*</b> in some kind of user interface, that may be a commandline or a **GUI** such as **Msty** or **LM Studio**.
2. The message gets converted by the interface into **[Json](https://en.wikipedia.org/wiki/JSON)** format that is compatible with the **OpenAI API** Rest WebService standard.
3. The **LLM** provider such as **Ollama** or **Llama.cpp** parses and transforms that **Json** into an internal format that is compatible with the specific **LLM** used.
This is typically depending on a correct **Modelfile** in **Go** template syntax (Ollama) or **chat_template** in **Jinja2** template syntax (Llama.cpp) template
so the provider knows how to *format* and *tokenize* the <b>*user message*</b> into the syntax understood by the **LLM**. 
That's why when a **LLM** get published which supports new features (e.g. **Gpt OSS 20B** supporting reasoning with tool and function calling), the
provider needs to be updated to correctly *format* the <b>*user message*</b> into the **LLM** specific syntax (so the LLM can respond on how the tool or function should be called).
4. The **LLM** *calculates* the most likely response according to the *formatted* and *tokenized* <b>*system message*</b> and <b>*user message*</b>.

The response, the <b>*assistant*</b> message is then returned to the user interface.

### Template format

The <b>*user message*</b> is *formatted* and *tokenized* in a way that allows the **LLM** to calculate the most likely response.
*Most likely* because an **LLM** neither understands what the user is talking about nor the meaning of its own response — it simply works with probabilities of data sequences.
All forms of input (words, tones, pixels, etc.) are converted into numbers — more precisely, into multi-dimensional vectors of numbers, called <b>*embeddings*</b>.
These numerical vectors represent the data in a way that captures its meaning or features, allowing the model’s neural network to process and reason about it mathematically.

In detail:

  - Text → Tokenized into words/subwords → each token is represented as a vector (embedding).
  - Speech/sound → Transformed into numerical features (e.g. spectrograms) → vectors.
  - Images → Pixel data or extracted features → vectors.

For this *tokenization* two template formats exist, the **Go** and the **Jinja2** template format.
This is important because the two formats are not fully compatible, that is **Jinja2** supports iterations which **Go** (the **Ollama** parser is
written in the Go language) does not support.
So using a **Jinja2** template may require rework of the processing logic in addition to translation to a **Go** template.

#### Go

For example:

```go
{{- if .System }}
<|system|>
{{ .System }}
<|end|>
{{- end }}
<|user|>
{{ .Prompt }}
<|end|>
<|assistant|>
```

  - <b>*.System*</b> and <b>*.Prompt*</b> are variables provided to the template.
  - The <b>*if*</b> block ensures the <b>*system message*</b> is optional.
  - Tags like <b>*<|user|>*</b> and <b>*<|assistant|>*</b> are special tokens that the model understands.

#### Jinja2

For example:

```
{% if system %}
<|system|>
{{ system }}
<|end|>
{% endif %}
<|user|>
{{ user }}
<|end|>
<|assistant|>
```

  - <b>*system*</b> and user are variables in the input context.
  - Similar structure to **Go**, but uses **Jinja2** syntax: <b>*{% %}*</b> for logic and <b>*{{ }}*</b> for variables.

### Llama.cpp

With **Llama.cpp** it is quite easy to observe how the messages are *formatted* and *tokenized* by the options <b>*--verbose-prompt*</b> and for more details the <b>*--verbose*</b> option, e.g.:

```bash
llama-cli --model "Mistral 7B Instruct v0.3\Mistral-7B-Instruct-v0.3-Q4_K_M.gguf" --ctx-size 32768 --n-gpu-layers 40 --jinja --verbose --verbose-prompt --prompt "Why is the sky blue?" --system-prompt "You are a scientific advisor!"
```

The messages logged to <b>*stderr*</b> for processing the <b>*user message*</b> <b>*Why is the sky blue?*</b> and the <b>*system message*</b> 
<b>*You are a scientific advisor!*</b> will include:

#### Metadata

After loading the **LLM** some configuration details (e.g. CUDA hardware, quantization, context size, training parameters, ...)  will be outputted.

#### Tensor

Details about the tensors (weights) loaded from a GGUF-format model file into memory during model initialization is outputted
on a block (layer) basis for transformer models.

#### Tokenization

*Tokenization* includes that the prompt is embedded in control tokens, which includes a <b>*EOG*</b> (end of generation) token to 
signal the end of the generation.
A token like e.g. <b>*<|eot|>*</b> in the template indicates that.

The <b>*user message*</b> and the optional <b>*system message*</b> (which may come from the **Modelfile** or **chat_template** templates if nothing is
supplied by a commandline option) is *tokenized* so the **LLM** understand how to process it.
With the e.g. **Mistral** **LLM** the *fromatted* prompt:

```
"[INST] You are a scientific advisor!
Why is the sky blue? [/INST]"
```

gets *tokenized* to:

```
[ '<s>':1, '[INST]':3, ' ':29473, ' You':1763, ' are':1228, ' a':1032, ' scientific':11237, ' advis':15077, 'or':1039, '!':29576, ' 
':781, 'Why':8406, ' is':1117, ' the':1040, ' sky':7980, ' blue':5813, '?':29572, ' ':29473, '[/INST]':4 ]
```

probably more readable this way:

```
main: number of tokens in prompt = 19
     1 -> '<s>'
     3 -> '[INST]'
 29473 -> ' '
  1763 -> ' You'
  1228 -> ' are'
  1032 -> ' a'
 11237 -> ' scientific'
 15077 -> ' advis'
  1039 -> 'or'
 29576 -> '!'
   781 -> '
'
  8406 -> 'Why'
  1117 -> ' is'
  1040 -> ' the'
  7980 -> ' sky'
  5813 -> ' blue'
 29572 -> '?'
 29473 -> ' '
     4 -> '[/INST]'
```

#### Inferencing

The response is then *predicted* by the **LLM**:

```
n_past = 19
n_remain: -2
 Theeval: [ ' The':1183 ]
n_past = 20
n_remain: -3
 skyeval: [ ' sky':7980 ]
n_past = 21
n_remain: -4
 appearseval: [ ' appears':8813 ]
n_past = 22
n_remain: -5
 blueeval: [ ' blue':5813 ]
n_past = 23
n_remain: -6
 dueeval: [ ' due':3708 ]
n_past = 24
n_remain: -7
 toeval: [ ' to':1066 ]
n_past = 25
n_remain: -8
 aeval: [ ' a':1032 ]
n_past = 26
n_remain: -9
 processeval: [ ' process':2527 ]
n_past = 27
n_remain: -10
 calledeval: [ ' called':2755 ]
n_past = 28
n_remain: -11
 Rayeval: [ ' Ray':9720 ]
n_past = 29
n_remain: -12
leeval: [ 'le':1059 ]
n_past = 30
n_remain: -13
igheval: [ 'igh':1724 ]
n_past = 31
n_remain: -14
 scatteringeval: [ ' scattering':22403 ]
...
```

that results in the formatted response to the user:

```
The sky appears blue due to a process called Rayleigh scattering. As sunlight reaches Earth, it is made up of different colors, which are actually different wavelengths of light. Shorter wavelengths, such as violet and blue, are scattered in all directions more than longer wavelengths, such as red and yellow.

However, our eyes are more sensitive to blue light and less sensitive to violet light, and the atmosphere scatters more blue light than violet. As a result, the sky appears blue to our eyes.

At sunrise and sunset, the light has to pass through a lot of atmosphere, and the shorter blue wavelengths are scattered out more than the longer red and yellow wavelengths. This is why the sky can appear red or orange during these times. Similarly, when the sun is low, the light has to pass through more air, increasing the amount of scattering.

On a clear day, the scattered blue light is evenly distributed in all directions. However, during sunrise or sunset, the scattered light is concentrated in the horizontal direction, which is why the sky appears red or orange during these times.

Overall, the color of the sky is a beautiful example of how light interacts with our atmosphere and how our perception of color plays a role in the way we experience the world.
```


## Hints

### NVidia-smi

When using a **NVidia** based **GPU** the driver installation will also install the tool <b>*NVidia-smi.exe*</b> (into <b>*C:\Windows\System32\*</b>.
This tool can be used to display details about the **GPU** usage, that is if a **LLM** is loaded the **VRAM** usage should reflect that,
if not the **LLM** probably is loaded by the **CPU** which means much less inferencing performance (less <b>*token/s*</b>).

Optionally you can run <b>*NVidia-smi.exe -l n*</b>, where <b>*n*</b> is the refresh rate in seconds. 
