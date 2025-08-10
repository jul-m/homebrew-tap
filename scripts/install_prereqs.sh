#!/bin/sh
# Prerequisites installation script for Homebrew Tap (POSIX sh)

# Install rbenv with Homebrew if not installed
if ! command -v rbenv >/dev/null 2>&1; then
    echo "Installing rbenv..."
    brew install rbenv
else
    echo "rbenv is already installed."
fi

# Install Ruby 3.4.4 with rbenv if not installed
if ! rbenv versions | grep -q 3.4.4; then
    echo "Installing Ruby 3.4.4..."
    rbenv install 3.4.4
else
    echo "Ruby 3.4.4 is already installed."
fi

# Install VSCode extensions from extensions.json
# (This part assumes the script is in scripts/ and extensions.json is in .vscode/ at project root)
echo "Installing VSCode extensions from extensions.json..."
if ! command -v code >/dev/null 2>&1; then
    echo "VSCode CLI not found. Please make sure VSCode is installed and the CLI is available in PATH."
else
    script_dir="$(dirname "$0")"
    project_dir="$(cd "$script_dir/.." && pwd)"
    extensions_file="$project_dir/.vscode/extensions.json"
    if [ -f "$extensions_file" ]; then
        echo "Found extensions.json at $extensions_file"
        # Extract extension IDs ("publisher.name") from the JSON file
        extensions=$(grep -o '"[^"]\+\.[^"]\+"' "$extensions_file" | tr -d '"')
        if [ -z "$extensions" ]; then
            echo "No extensions found in $extensions_file"
        else
            for ext in $extensions; do
                echo "Installing extension: $ext"
                code --install-extension "$ext"
            done
        fi
        echo "VSCode extensions installed successfully."
    else
        echo "No extensions.json file found at $extensions_file"
    fi
fi

echo "All prerequisites are installed. Please restart VSCode to apply changes."
