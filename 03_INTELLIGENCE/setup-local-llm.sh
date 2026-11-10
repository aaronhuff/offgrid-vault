#!/usr/bin/env bash
# ==============================================================================
# setup-local-llm.sh - Run offline LLM inference on this laptop (Podman + Ollama)
# ==============================================================================
set -euo pipefail

VAULT_DIR="/var/home/aaronhuff/offgrid-vault"
MODELS_DIR="$VAULT_DIR/03_INTELLIGENCE"

echo "=== Offline LLM Setup for Bluefin / Linux Laptop ==="

# Check if podman is installed
if ! command -v podman &>/dev/null; then
    echo "Error: podman not found."
    exit 1
fi

# Create persistent storage directory for Ollama inside the vault
mkdir -p "$MODELS_DIR/ollama_home"

echo "Starting Ollama container via Podman (Local-only, port 11434)..."
podman run -d \
    --name offgrid-ollama \
    --restart unless-stopped \
    -v "$MODELS_DIR/ollama_home:/root/.ollama:Z" \
    -p 127.0.0.1:11434:11434 \
    docker.io/ollama/ollama:latest 2>/dev/null || {
        echo "Container already exists or running. Ensuring it is started..."
        podman start offgrid-ollama
    }

echo "Ollama is ready at http://127.0.0.1:11434"
echo ""
echo "To pull the offline models while online, run:"
echo "  podman exec -it offgrid-ollama ollama pull qwen2.5-coder:7b"
echo "  podman exec -it offgrid-ollama ollama pull llama3.2:3b"
echo "  podman exec -it offgrid-ollama ollama pull llama3.2:1b"
echo ""
echo "To chat with a model offline:"
echo "  podman exec -it offgrid-ollama ollama run qwen2.5-coder:7b"
echo "========================================================="
