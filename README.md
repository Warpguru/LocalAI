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

A few words on how a user message such as e.g. <b>*Why is the sky blue?*</b> gets processed to an answer such as e.g. <b>*Because of Rayleigh scattering.*</b>.

![Message processing](.\doc\LLM.png "Message Processing")

The <b>*user*</b> message, which may be multi-media not just text, is sent to the **LLM**:

1. The user enters the message in some kind of user interface, that may be a commandline or a **GUI** such as **Msty** or **LM Studio**.
2. The message gets converted by the interface into **[Json](https://en.wikipedia.org/wiki/JSON)** format that is compatible with the **OpenAI API** Rest WebService standard.
3. The **LLM** provider such as **Ollama** or **Llama.cpp** parses and transforms that **Json** into an internal format that is compatible with the specific **LLM** used.
This is typically depending on a correct **Modelfile** in **Go** template syntax (Ollama) or **chat_template** in **Jinja2** template syntax (Llama.cpp) template
so the provider knows how to *format* and *tokenize* the user message into the syntax understood by the **LLM**. 
That's why when a **LLM** get published which supports new features (e.g. **Gpt OSS 20B** supporting reasoning with tool and function calling), the
provider needs to be updated to correctly *format* the user message into the **LLM** specific syntax (so the LLM can respond on how the tool or function should be called).
4. The **LLM** *calculates* the most likely response according to the *formatted* and *tokenized* user message.

The response, the <b>*assistant*</b> message is then returned to the user interface.

### Template format

The <b>*user*</b> message is *formatted* and *tokenized* in a way that allows the **LLM** to calculate the most likely response.
*Most likely* because an **LLM** neither understands what the user is talking about nor the meaning of its own response — it simply works with probabilities of data sequences.
All forms of input (words, tones, pixels, etc.) are converted into numbers — more precisely, into multi-dimensional vectors of numbers, called <b>*embeddings*</b>.
These numerical vectors represent the data in a way that captures its meaning or features, allowing the model’s neural network to process and reason about it mathematically.

In detail:

  - Text → Tokenized into words/subwords → each token is represented as a vector (embedding).
  - Speech/sound → Transformed into numerical features (e.g. spectrograms) → vectors.
  - Images → Pixel data or extracted features → vectors.

For this *tokenization* two template formats exist, the **Go** and the **Jinja2** template format.

#### Go


#### Jinja2

## Hints

### NVidia-smi

When using a **NVidia** based **GPU** the driver installation will also install the tool <b>*NVidia-smi.exe*</b> (into <b>*C:\Windows\System32\*</b>.
This tool can be used to display details about the **GPU** usage, that is if a **LLM** is loaded the **VRAM** usage should reflect that,
if not the **LLM** probably is loaded by the **CPU** which means much less inferencing performance (less <b>*token/s*</b>).

Optionally you can run <b>*NVidia-smi.exe -l n*</b>, where <b>*n*</b> is the refresh rate in seconds. 
