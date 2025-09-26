# LocalAI

## Abstract

This project contains a template directory structure to run LLMs locally (both OpenAI API compatible servers and clients).

## Hints

### NVidia-smi

When using a **NVidia** based **GPU** the driver installation will also install the tool <b>*NVidia-smi.exe*</b> (into <b>*C:\Windows\System32\*</b>.
This tool can be used to display details about the **GPU** usage, that is if a **LLM** is loaded the **VRAM** usage should reflect that,
if not the **LLM** probably is loaded by the **CPU** which means much less inferencing performance (less <b>*token/s*</b>).

Optionally you can run <b>*NVidia-smi.exe -l n*</b>, where <b>*n*</b> is the refresh rate in seconds. 
