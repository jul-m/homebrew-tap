#!/usr/bin/env fish
# Script to install all prerequisites for Homebrew tap development with VSCode

# Install rbenv with Homebrew if not installed
if not type -q rbenv
    echo "Installing rbenv..."
    brew install rbenv
else
    echo "rbenv is already installed."
end

# Install Ruby 3.4.4 with rbenv if not installed
if not rbenv versions | grep -q 3.4.4
    echo "Installing Ruby 3.4.4..."
    rbenv install 3.4.4
else
    echo "Ruby 3.4.4 is already installed."
end

# Install VSCode extensions from extensions.json
echo "Installing VSCode extensions from extensions.json..."
if not type -q code
    echo "VSCode CLI not found. Please make sure VSCode is installed and the CLI is available in PATH."
else
    # Utilisons le chemin absolu pour être sûr de trouver le fichier
    set script_dir (dirname (status -f))
    set project_dir (realpath "$script_dir/..")
    set extensions_file "$project_dir/.vscode/extensions.json"
    
    if test -f $extensions_file
        echo "Found extensions.json at $extensions_file"
        
        # Approche plus simple pour extraire les noms des extensions
        # On extrait les lignes qui contiennent un ID d'extension entre guillemets
        set extensions_data (cat $extensions_file | grep -o '"[^"]\+\.[^"]\+"')
        
        if test (count $extensions_data) -eq 0
            echo "No extensions found in $extensions_file"
        else
            for ext in $extensions_data
                # Supprime les guillemets
                set clean_ext (echo $ext | tr -d '"')
                echo "Installing extension: $clean_ext"
                code --install-extension $clean_ext
            end
        end
        
        echo "VSCode extensions installed successfully."
    else
        echo "No extensions.json file found at $extensions_file"
    end
end

echo "All prerequisites are installed. Please restart VSCode to apply changes."
