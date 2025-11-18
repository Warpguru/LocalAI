# N8n

**N8n** is an AI Workflow automation tool.

## Prerequisites

### Node

The installation of **N8n** requires that **[Node](https://nodejs.org/)** is installed and accessible.
This repository does not include any **Node** instance, thus download e.g. version <b>*22.15.1*</b> of 
[Node](https://nodejs.org/dist/v22.15.1/node-v22.15.1-win-x64.zip) and unpack it into a directory e.g. <b>*D:\Node\22.15.1\*</b>.

To run **Node** adapt the following template batch script <b>*SetupEnvNode.cmd*</b> accordingly:

```SetupEnvNode.cmd
@ECHO OFF
SET CURRENTDIRECTORY=%~dp0
SET NODE=D:\Node\22.15.1

SET PATH=%NODE%;%PATH%
```

### Python3

To run **N8N** a full (not just embedded) **[Python 3](https://www.python.org/downloads/windows/)** environment is required.
When available adapt and run <b>*SetupEnvPython3.cmd*</b>:

```SetupEnvPython3.cmd
@ECHO OFF
SET CURRENTDIRECTORY=%~dp0
SET PYTHON=D:\Python\3.11.9

REM Either have directories in python311._pth or in PYTHONPATH environment variable
REM See: https://michlstechblog.info/blog/python-install-python-with-pip-on-windows-by-the-embeddable-zip-file/
REN %PYTHON%\python311._pth python311._pth.original
SET PATH=%PYTHON%;%PYTHON%\Scripts;%PYCHARM%\bin;%PATH%
SET PYTHONPATH=%PYTHON%;%PYTHON%\DLLs;%PYTHON%\lib;%PYTHON%\lib\plat-win;%PYTHON%\lib\site-packages
```

**Note!** **Whisper** only supports Python <b>*3.11.9</b> which is a somewhat older version.

## Installation

To install (which will take a while) or execute **N8n** run <b>*SetupEnvN8n.cmd*</b>.
When using **Whisper** preferably run it from the <b>*.\Whisper*</b> subdirectory:

```SetupEnvN8n.cmd
@ECHO OFF
SET CURRENTDIRECTORY=%~dp0
SET USERPROFILE=%CURRENTDIRECTORY%Users\N8n
SET APPDATA=%CURRENTDIRECTORY%Users\N8n\AppData\Roaming
SET LOCALAPPDATA=%CURRENTDIRECTORY%Users\N8n\AppData\Local
IF NOT EXIST "%APPDATA%" MKDIR "%APPDATA%" >NUL
IF NOT EXIST "%LOCALAPPDATA%" MKDIR "%LOCALAPPDATA%" >NUL

@uv venv
@.venv\Scripts\activate
ECHO.
ECHO Start N8N by: npx n8n
```

## Usage

Run **N8n** preferably from the <b>*.\Whisper*</b> subdirectory when using **Whisper** :

```
npx n8n
```

Running **N8n** for the first time requires to create credentials and it is recommended to register **N8n** to unlock
lifetime free options.

# Whisper

**[Whisper](https://github.com/openai/whisper)** is a general-purpose speech recognition model.
It is trained on a large dataset of diverse audio and is also a multitasking model that can perform multilingual speech recognition,
speech translation, and language identification.

## Prerequisites

In addition to the prerequisites of **N8n** the following tools are required.

### Git

The installation of **Whisper** requires **Git**:

```SetupEnvGit.cmd
@ECHO OFF
SET CURRENTDIRECTORY=%~dp0
SET GIT=D:\Development\Git\bin

SET PATH=%GIT%;%PATH%
```

### FFMpeg

**Whisper** uses **[FFMpeg](https://www.videohelp.com/download/ffmpeg-8.0-full_build.7z)** under the hood to convert the input media 
into an certain audio format to transcribe the media.

```SetupEnvFFMpeg.cmd
@ECHO OFF
SET CURRENTDIRECTORY=%~dp0
SET FFMPEG=D:\Development\FFMPEG

SET PATH=%FFMPEG%\bin;%PATH%
```

## Installation

Install **Whisper** into the virtual **Python** environment in the <b>*.\Whisper*</b> subdirectory:

```
pip install --upgrade pip setuptools wheel
pip install --no-build-isolation git+https://github.com/openai/whisper.git
```

To verify the installation run:

```
python -c "import whisper; print(whisper.__version__)"
```

which responds with the release date of your **Whisper** version.

## Usage

To transcribe the audio with **Whisper** run e.g. (which will also be the template of the command for an automated workflow
with **N8n**) from the <b>*.\Whisper*</b> subdirectory:
 
```
python -m whisper ".\input\<Video.mkv>" --output_dir .\output --output_format all --model medium
```

# WhisperX

**[WhisperX](https://github.com/m-bain/whisperX)** is a general-purpose speech recognition model.
While Whisper performs the core speech-to-text, WhisperX adds post-processing steps like voice activity detection and forced 
alignment to provide these enhanced results, whereas standard Whisper lacks the built-in tools for speaker identification and 
accurate word timing.

**WhisperX** can either run on the **CPU** or on the **GPU** (about 20x faster compared to the CPU).
While both **NVidia** and **AMD** **GPU**s are supported, this guide focuses on the most widely used **GPU** acceleration
infrastructure, that is **NVidia CUDA**. 

## Cuda Toolkit

To use hardware accelerationwith **WhisperX** the **NVidia** **[CUDA Toolkit](https://developer.nvidia.com/cuda-downloads)** needs to be installed.
At the time of writing the release was [Version 13.0.2](Cuda_13.0.2_windows.exe).  

## Prerequisites

In addition to the prerequisites of **Whisper** the following tools are required for **WhisperX**.

### HuggingFace

**WhisperX** requires to access free tools from **[HuggingFace](https://huggingface.co/)**.
To allow using this tools you need:

1. An account on **HuggingFace**
2. Login to **HuggingFace** and select <b>*Profile&#x2192;Access Token*</b> to create an **Access Token** (<b>*Read*</b> permission is sufficient)
3. Agree to access **Diarization** models.
   You need to enter your <b>*Company/University*</b> (just use your eMail) and WebSite (e.g. your GitHub account) before selecting <b>*Agree and access repository*</b>.
   Failing to do so will result in error messages when **WhisperX** accesses these models.  
    * [Speaker Diarization](https://huggingface.co/pyannote/speaker-diarization)
    * [Speaker Diarization 3.0](https://huggingface.co/pyannote/speaker-diarization-3.0)
    * [Speaker Diarization 3.1](https://huggingface.co/pyannote/speaker-diarization-3.1)

4. Agree to access **Segmentation** models.
   You need to enter your <b>*Company/University*</b> (just use your eMail) and WebSite (e.g. your GitHub account) before selecting <b>*Agree and access repository*</b>.
   Failing to do so will result in error messages when **WhisperX** accesses these models.  
    * [Segmentation](https://huggingface.co/pyannote/segmentation)
    * [Segmentation 3.0](https://huggingface.co/pyannote/segmentation-3.0)

## Installation

### Virtual environment

Create a virtual **Python** environment for **WhisperX**:

```
python -m venv .venv --prompt WhisperX
```

**Important!** You must modify your virtual **Python** environment so it loads libraries from your virtual environment
before the ones inherited from the **Python** installation!

Run the command: <b>*notepad .venv\Lib\sitecustomize.py*</b> to verify that the file <b>*.venv\Lib\sitecustomize.py*</b>
exists and contains:

```sitecustomize.py
import sys
import os

if 'VIRTUAL_ENV' in os.environ:
    venv = os.environ['VIRTUAL_ENV']
    site_packages = os.path.join(venv, 'Lib', 'site-packages')
    sys.path.insert(0, site_packages)
    sys.path.insert(0, venv)
    print("Sitecustomize.py adjusted sys.path() ...")
```

Finally you can activate your virtual **Python** environment:

```
venv\Scripts\activate
```

### PyTorch

To install **PyTorch** first ensure that **Pip** is up to date:

```
uv pip install --upgrade pip
```

Then install the **CPU** support libraries (**Note!** The version <b>*2.8.0*</b> for **CPU** support are newer and new versions
are available much more frequently than the **GPU** versions):

```
uv pip install torch==2.8.0 torchaudio==2.8.0 --index-url https://download.pytorch.org/whl/cpu
```

and the **GPU** support libraries:

```
uv pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
```

### WhisperX

Finally install **WhisperX** from its **Github** repository:

```
uv pip install git+https://github.com/m-bain/whisperX.git
```

## Verification

In order to avoid subtle error message running **WhisperX** first verify from you activated virtual **Pyhton** environment
your installation.

### Library paths 

Verify that the library paths from your virtual **Python** environment precede the ones inherited from your **Python** installation.
Your installation should look like this:

```
(WhisperX) D:\LocalAI\N8n\WhisperX>python -c "import sys; print('\n'.join(sys.path))"

D:\LocalAI\N8n\WhisperX\.venv
D:\LocalAI\N8n\WhisperX\.venv\Lib\site-packages
D:\Python\3.11.9\python311.zip
D:\Python\3.11.9\DLLs
D:\Python\3.11.9\Lib
D:\Python\3.11.9
```

### CUDA

As not every version of **PyTorch** is supported with **CUDA** ensure that you are using a compatible version.
For **GPU** support the version returned should be (for **CPU** support the version most likely is more recent,
e.g. <b>*2.8.0*</b>):

```
(WhisperX) D:\LocalAI\N8n\WhisperX>uv run python -c "import torch; print(torch.__version__, 'CUDA:', torch.version.cuda, 'Available:', torch.cuda.is_available())"
2.5.1+cu121 CUDA: 12.1 Available: True
```

If a different version is displayed and you encounter errors running **WhisperX** reinstalling a supported version my be necessary:

```
(WhisperX) D:\LocalAI\N8n\WhisperX>uv run python -m pip uninstall -y torch torchaudio
(WhisperX) D:\LocalAI\N8n\WhisperX>uv run python -m pip install --no-cache-dir --force-reinstall torch==2.5.1+cu121 torchaudio==2.5.1+cu121 --index-url https://download.pytorch.org/whl/cu121
```

After reinstallation verify that version <b>*2.5.1+cu121*</b> is available now.
Of course, you can run **WhisperX** without **GPU** support, but only much slower.

To check if **WhisperX** has **GPU** support installed execute the following command:

```
(WhisperX) D:\LocalAI\N8n\WhisperX>uv run python -m torch.utils.collect_env
Collecting environment information...
PyTorch version: 2.5.1+cu121
Is debug build: False
CUDA used to build PyTorch: 12.1
ROCM used to build PyTorch: N/A
...

```

## Usage

To transcribe the audio of a video with speaker diarization ensure you have set your **HuggingFace** access token <b>*<HuggingFaceToken>*</b>
before executing the **WhisperX** command:

```
SET HF_TOKEN=<HuggingFaceToken>
(WhisperX) D:\LocalAI\N8n\WhisperX>whisperx "<Videofile>" --device=cuda --model "<Model>" --compute_type float32 --diarize --diarize_model <DiarizationModel> --align_model "<AlignmentModel>" --batch_size 4 --max_line_width 52 --max_line_count 1 --hf_token %HF_TOKEN% --output_dir <OutputFolder> --output_format all
```

where:

* <b>*<Videofile>*</b> is the fully qualified path to the video whose audio should be transcribed
* <b>*<Model>*</b> is one of the [voice models](https://whisper-api.com/blog/models/), leave out <b>*.en*</b> is a multilanguage model is
required (the larger the model, the more accurate and slower the transcription):
    * tiny.en (38M parameters)
    * base.en (74M parameters)
    * small.en (244M parameters
    * medium.en (759M parameters)
    * large-v1, large-v2, large-v3 or large (1.5B parameters)
* <b>*<DiarizationModel>*</b> is one of the following diarization models (your mileage may vary on the model you use):
    * pyannote/speaker-diarization
    * pyannote/speaker-diarization-3.0
    * pyannote/speaker-diarization-3.1
* <b>*<AlignmentModel>*</b> is one of the alignment models (the larger the model, the more accurate and slower the transcription):
    * facebook/wav2vec2-base-960h (94M parameters)
    * facebook/wav2vec2-large-960h-lv60 (317M parameters)
    * jonatasgrosman/wav2vec2-large-xlsr-53-english (317M parameters)
* <b>*<OutputFolder>*</b> is the folder to output all formats (**JSON**, **SRT**, **TXT**, ... when the option <b>*all*</b> is 
specified for <b>*--output_format*</b>.

Run **WhisperX** without any parameters to display the supported parameters.

# Workflows

See **[N8n](https://n8n.io/)** for more information.
