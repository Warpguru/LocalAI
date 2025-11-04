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

To run <b>*ClaudeProxy.py*</b> a **[Python 3](https://www.python.org/downloads/windows/)** environment is required.
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

# Workflows

See **[N8n](https://n8n.io/)** for more information.

