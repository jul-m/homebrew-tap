#!/bin/sh
# Script to download or update the main Homebrew stubs for a tap repository
stub_dir="sig"

# List of main stubs to fetch
urls="
https://raw.githubusercontent.com/Homebrew/brew/master/Library/Homebrew/formula.rb
https://raw.githubusercontent.com/Homebrew/brew/master/Library/Homebrew/resource.rb
https://raw.githubusercontent.com/Homebrew/brew/master/Library/Homebrew/requirement.rb
https://raw.githubusercontent.com/Homebrew/brew/master/Library/Homebrew/cask/cask.rb
https://raw.githubusercontent.com/Homebrew/brew/master/Library/Homebrew/language/python.rb
https://raw.githubusercontent.com/Homebrew/brew/master/Library/Homebrew/language/node.rb
"

mkdir -p "$stub_dir"

for url in $urls; do
  fname=$(basename "$url")
  curl -fsSL "$url" -o "$stub_dir/$fname"
  echo "Downloaded: $stub_dir/$fname"
done

echo "All main Homebrew stubs are up to date in $stub_dir"
