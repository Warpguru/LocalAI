"""
gguf_to_modelfile.py
--------------------
Extracts the chat_template from a GGUF model file
and generates a Modelfile compatible with Ollama.

Usage:
    python gguf_to_modelfile.py path/to/model.gguf [output_modelfile]

Example:
    python gguf_to_modelfile.py llama3-instruct.gguf
"""

import sys
from pathlib import Path
from gguf import GGUFReader

def main():
    if len(sys.argv) < 2:
        print("Usage: python gguf_to_modelfile.py path/to/model.gguf [output_modelfile]")
        sys.exit(1)

    gguf_path = Path(sys.argv[1])
    if not gguf_path.exists():
        print(f"Error: file not found -> {gguf_path}")
        sys.exit(1)

    output_path = Path(sys.argv[2]) if len(sys.argv) > 2 else Path("Modelfile")

    # Read the GGUF metadata
    reader = GGUFReader(gguf_path)
    chat_template = None

    for kv in reader.metadata_kv():
        if "chat_template" in kv.key:
            chat_template = kv.value
            break

    if not chat_template:
        print("⚠️  No chat_template found in this GGUF file.")
        print("   (This may be a base model or fine-tuned model without chat formatting.)")
        sys.exit(1)

    # Write the Modelfile
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(f"FROM ./{gguf_path.name}\n\n")
        f.write("TEMPLATE \"\"\"\n")
        f.write(chat_template.strip() + "\n")
        f.write("\"\"\"\n")

    print(f"✅ Modelfile created successfully: {output_path}")
    print("👉 You can now run:\n   ollama create mymodel -f Modelfile")

if __name__ == "__main__":
    main()
