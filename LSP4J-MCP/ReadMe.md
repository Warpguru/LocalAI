# LSP4J-MCP

An MCP server that exposes Java code intelligence (find symbols, references, definitions, etc.) via the Eclipse JDT Language Server.

## How it works

**[JDTLS](https://github.com/eclipse-jdtls/eclipse.jdt.ls)** (Eclipse JDT Language Server) is the same Java analysis engine that powers Eclipse IDE and VS Code's Java extension. It understands your Java source code deeply: it indexes every class, method, and field; resolves imports; tracks where every symbol is defined and used. It speaks the [Language Server Protocol](https://microsoft.github.io/language-server-protocol/) (LSP), a standard JSON-RPC wire format designed so that any editor or tool can ask a language engine questions ("where is this method defined?", "what calls this function?") without knowing anything about Java itself.

**[LSP4J](https://github.com/eclipse-lsp4j/lsp4j)** is the official Eclipse Java library that implements the LSP wire format, so Java programs can talk to a language server without writing raw JSON-RPC by hand.

**[LSP4J-MCP](https://github.com/stephanj/LSP4J-MCP)** is a small bridge that sits between any [MCP](https://modelcontextprotocol.io/)-capable AI assistant (Bob, Claude Code, Cursor, etc.) and JDTLS. It:

1. Launches JDTLS as a subprocess.
2. Uses LSP4J to communicate with it over standard input/output.
3. Wraps the results as MCP tools — the protocol AI assistants use to call external capabilities.

The net effect is that any MCP client can ask "find all references to method `processOrder`" and get back exact file locations, without any static parsing, without an open editor, and without reading every source file into the AI context.

```mermaid
flowchart LR
    AI[MCP client] -->|MCP| LSP4J-MCP -->|LSP4J| JDTLS -->|indexes| Java[Java source]
```

## Available tools

Once the MCP server is running, the following tools are exposed to the AI assistant:

| Tool | Description | Notes from trial run |
|---|---|---|
| `find_symbols` | Search for Java symbols (classes, methods, fields) by name across the indexed project | Works well. Returns symbol kind, containing package, file path, and line/column. May return duplicates when the same symbol is matched via multiple containers. |
| `find_references` | Find all locations in the codebase that reference a symbol at a given file and position | Works accurately. Returns precise file, line, and column ranges for each call site, including the declaration itself. Useful as a first step to locate call sites before invoking `find_definition`. |
| `find_definition` | Resolve the declaration of a symbol at a given file and position | Works well. Most valuable when called from a **call site** rather than the declaration itself — it correctly navigates across files to the method's definition, replicating IDE "Go to Definition" behaviour. |
| `document_symbols` | List all symbols (classes, methods, fields) defined in a single Java file | Works well. Returns a clean, ordered list of all members with their kind and line range — useful for getting a quick structural overview of a file, and for resolving exact line/column coordinates needed by `find_references` and `find_definition`. |
| `find_interfaces_with_method` | Find all interfaces that declare a method with a given name | ⚠️ Behaves unexpectedly. Instead of returning interface declarations, it returns all types associated with the method (the containing class, the return type, etc.), each as a separate entry. The `kind` field is always `"Method"` rather than `"Interface"`. Does not currently fulfil its stated purpose. |

---

## Prerequisites

- Java 21
- Maven
- Git

---

## Setup

### 1. Clone and build

```bat
cd x:\Workspace
git clone https://github.com/stephanj/LSP4J-MCP.git
cd LSP4J-MCP
mvn clean source:jar install -DskipTests
```

The JAR is produced at `target\lsp4j-mcp-1.0.0-SNAPSHOT.jar`.  
Tests are skipped because they require a running JDTLS instance.

---

### 2. Install JDTLS

Download from:
```
https://download.eclipse.org/jdtls/milestones/1.60.0/jdt-language-server-1.60.0-202606262232.tar.gz
```

Extract to e.g. `D:\Development\JdtLs`. The directory should contain `plugins\`, `features\`, `config_win\`, etc.

---

### 3. Create a JDTLS launcher script

The bundled `bin\jdtls.bat` requires Python to resolve the launcher JAR path. The script below does the same without Python.

Create `D:\Development\JdtLs\JDTLS.Runme.cmd`:

```bat
@echo off

set JDTLS_HOME=D:\Development\JdtLs

for %%f in ("%JDTLS_HOME%\plugins\org.eclipse.equinox.launcher_*.jar") do (
    set LAUNCHER=%%f
)

C:\Programs\Java\Java21\bin\java ^
  -Declipse.application=org.eclipse.jdt.ls.core.id1 ^
  -Dosgi.bundles.defaultStartLevel=4 ^
  -Declipse.product=org.eclipse.jdt.ls.core.product ^
  -Dosgi.checkConfiguration=true ^
  -Dosgi.sharedConfiguration.area=%JDTLS_HOME%\config_win ^
  -Dosgi.sharedConfiguration.area.readOnly=true ^
  -Dosgi.configuration.cascaded=true ^
  -Xms1G ^
  --add-modules=ALL-SYSTEM ^
  --add-opens java.base/java.util=ALL-UNNAMED ^
  --add-opens java.base/java.lang=ALL-UNNAMED ^
  -jar "%LAUNCHER%" ^
  -data "%APPDATA%\jdtls\workspace"
```

Adjust `JDTLS_HOME` and the Java path if your installation differs.

---

### 4. Smoke-test the MCP server

Run the JAR directly, passing the project directory to analyse and the JDTLS launcher script:

```bat
c:\Programs\Java\Java21\bin\java -jar D:\Workspace\LSP4J-MCP\target\lsp4j-mcp-1.0.0-SNAPSHOT.jar ^
  D:\Workspace\LSP4J-MCP ^
  D:\Development\JdtLs\JDTLS.Runme.cmd
```

Arguments:
1. Path to the Java project you want to index.
2. Path to the JDTLS launcher script created in step 3.

If JDTLS starts cleanly you will see it initialise and accept LSP messages over stdio.

To inspect the JDTLS workspace log:

```bat
type %APPDATA%\jdtls\workspace\.metadata\.log
```

---

### 5. Register with Bob (MCP config)

Add the following entry to your Bob MCP server configuration:

```json
"java-lsp": {
  "command": "C:\\Programs\\Java\\Java21\\bin\\java.exe",
  "args": [
    "-jar",
    "D:\\Workspace\\LSP4J-MCP\\target\\lsp4j-mcp-1.0.0-SNAPSHOT.jar",
    "D:\\Workspace\\JavaOpenAI",
    "D:\\Development\\JdtLs\\JDTLS.Runme.cmd"
  ],
  "env": {
    "LOG_FILE": "D:\\Workspace\\LSP4J\\Lsp4j-mcp.log"
  },
  "disabled": false,
  "alwaysAllow": [
    "find_symbols",
    "find_references",
    "find_definition",
    "document_symbols",
    "find_interfaces_with_method"
  ],
  "timeout": 120000
}
```

- `args[2]`: the Java project directory Bob should analyse.
- `args[3]`: path to `Copilot.Runme.cmd` from step 3.
- `LOG_FILE`: path where the MCP server writes its own log (directory must exist).

Set `"disabled": false` once the smoke-test passes.
