# Cursor

## Installation

To create a portable installation of **Cursor**:

1. Download **[Cursor](https://cursor.com/download)** (e.g. <b>*CursorSetup-x64-1.7.54.exe*</b>* and install it with the default settings
except registering it as an editor and modifying the path and launch it once
2. Log in with e.g. your **Google** account
3. Copy the **Cursor** program and configuration to this repository folder (replace <b>*User*</b> with your username):

   ```
   XCOPY "X:\Users\<User>\AppData\Local\Programs\cursor" .\Cursor\ /s /e /v
   ```
4. Deinstall **Cursor** again

## Usage

Initialize the portable **Cursor** environment by <b>*SetupEnvCursor.cmd*</b>:

```SetupEnvCursor.cmd
@ECHO OFF
SET CURRENTDIR=%~dp0
SET USERPROFILE=%CURRENTDIR%Users\Cursor
SET APPDATA=%CURRENTDIR%Users\Cursor\Appdata\Roaming
SET LOCALAPPDATA=%CURRENTDIR%Users\Cursor\AppData\Local
IF NOT EXIST "%CURRENTDIR%" MKDIR "%CURRENTDIR%" >NUL
IF NOT EXIST "%LOCALAPPDATA%" MKDIR "%LOCALAPPDATA%" >NUL

ECHO.
Start "Cursor" cmd.exe /K ".\Cursor\Cursor"
```

Start **Cursor** with the command <b>*.\Cursor\Cursor.exe*</b>.
When running **Cursor** for the first time it requests to sign up or login with your **Cursor** account, you may want to login
with your **Google** account.
Deselect all additional tasks **Cursor** may recommend. 

## Configuration

Theoretically **Cursor** supports other **LLM**s too including **Open AI API** compatible ones.
**However, with the version mentioned above this doesn't work.**
**Cursor** does retrieve the **LLM**s provided by **Open AI API** compatible providers such as **Ollama** and **Llama.cpp**,
but still uses the built-in models (even when they are all deselected).
This topic is discussed on the internet and no working solutions is available at the moment.

[See also here Method 4: API Proxy Implementation (Advanced)!!!](https://blog.laozhang.ai/development-tools/integrating-cursor-with-laozhang-ai-api/)
<b>In your Cursor project directory
Create or edit .env file

OPENAI_API_KEY=your_laozhang_api_key
OPENAI_API_BASE_URL=https://api.laozhang.ai/v1
</b>

**Cursor** seems to require a **bash** shell for some actions (at least it logs that when starting it with the <b>*--verbose*</b> option).
To configure that shell: 

1. Open the settings by pressing <b>*Ctrl+,*</b> and then clicking on the <b>*page edit*</b> icon at the top right
2. Add the path to <b>*bash.exe*</b> as shown:

   ```
   {
       "window.commandCenter": true,
       "workbench.colorTheme": "Cursor Dark High Contrast",
       "terminal.integrated.profiles.windows": {
           // Make sure Git Bash or your WSL distro is defined here
           // VS Code/Cursor usually finds them, but you can add manually:
           "Git Bash": {
             "path": "D:\\Development\\Git\\bin\\bash.exe", // <-- *CHECK THIS PATH!*
             "icon": "terminal-bash"
           }  
       }  
   }
   ```

In theory, to configure an **Open AI API** compatible **LLM** the following steps are recommended:

1. Click the <b>*Gear*</b> icon to open the **Settings** dialog
2. Select **Models**
3. Disable all **LLM** models
4. Select **Add Custom Model**
5. Add a local **LLM** model, e.g. <b>*llama3:latest*</b> (or any other model shown be **Ollama** with <b>*..\Ollama\Ollama.exe list*</b>
6. Select **API Keys**
7. Select **Override OpenAI Base URL** and enter the **Url** to you local **LLM**, e.g. <b>*https://313061f6a5eb.ngrok-free.app/v1*</b>
8. Restart **Cursor**

**Hint!** Some information says **Cursor** does not support a port in the url (so in the example above **[NGrok](https://ngrok.com/)**
was used to expose the url of a locally hosted **LLM** at <b>*http://localhost:11434/*</b> to a standard **HTTP** url), however
when configuring the url <b>*http://localhost:8888/v1*</b> to route the messages to **Ollama** over the **[Fiddler](https://www.telerik.com/fiddler)**
reverse proxy **Cursor** again just retrieves the **LLM** models via a **HTTP GET** at <b>*http://localhost:11434/v1/models*</b>
but doesn't use them.

One recommendation also is to manually define the  **Open AI API** compatible **LLM** in <b>*settings.json*</b>, though that
still does't help:

1. Open the settings by pressing <b>*Ctrl+,*</b> and then clicking on the <b>*page edit*</b> icon at the top right
2. Add the **OpenAI API** compatible **LLM** as shown:

   ```
   {
       "ai.requestTimeoutMs": 60000,
       "defaultProvider": "local",
       "localLLM": {
           "provider": "openai",
           "url": "https://313061f6a5eb.ngrok-free.app/v1",
           "model": "llama3.2:3b"
       }
   }
   ```

## Proxy

Instead of specifying the **OpenAI API** compatible **LLM** provider e.g. **Ollama**, you can specify a reverse proxy that forward the requests while also logging them.

### JavaForwarder

For example, after starting **[JavaForwarder](https://github.com/Warpguru/JavaForwarder)** with:

```
java -DDUMP=True -DDUMP_WIDTH=32 -jar JavaForwarder.jar 127.0.0.1 <port> 8888
```

where <b>*port*</b> is the port of your **LLM** provider's **OpenAI API** interface (e.g. <b>*10000*</b> for **Llama.cpp** or
<b>*11434*</b>* for **Ollama**) and defining <b>*http://127.0.0.1:8888/v1</b> as the **OpenAI API** compatible **LLM** as shown above.
The communication between **Cursor** and the **LLM** exposed by e.g. **Ollama** will be logged in the command prompt **JavaForwarder** was started from.

### Fiddler

Alternatively you can configure **Fiddler** as an **OpenAI API** compatible **LLM** at the default Url <b>*http://localhost:8888/v1</b> 
(<b>*localhost*</b> must match the hostname or IP address used in the rules editor as shown below).
**Fiddler** will now log the communication between **Cursor** and the **LLM** exposed by e.g. **Ollama**, which can be verified best by switching the viewer to format the body to **Json** format.

In order for **[Fiddler](https://www.telerik.com/fiddler)** to reverse proxy the request invoke the rules editor from <b>*Rules*</b>→<b>*Customize Rules...*</b> and add as the first lines to the <b>*OnBeforeRequest*</b> handler:

**Note!** If the **LLM** provider is on a remote host change <b>*localhost*</b> to the remote hosts hostname accordingly. 

#### Ollama

```
// Forward traffic to Ollama server
if (oSession.host.toLowerCase() == "localhost:8888") oSession.host = "localhost:11434"; 
```

#### Llama.cpp

```
// Forward traffic to Llama.cpp server
if (oSession.host.toLowerCase() == "localhost:8888") oSession.host = "localhost:10000"; 
```

#### LM Studio

```
// Forward traffic to LMStudio llama.cpp server
if (oSession.host.toLowerCase() == "localhost:8888") oSession.host = "localhost:1234"; 
```
