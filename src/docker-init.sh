#!/usr/bin/env bash
set -e
# --- Destination directory ---
DEST_DIR="${REPO_DEST:-$HOME/lists}"  # default to ~/repos if not set
# git config --global --add safe.directory "$DEST_DIR"

# --- List of git clone URLs ---
# If $GIT_REPOS contains a YAML-style list, convert it into an array
# Handles space-separated or quoted URLs

if [ -z "$GIT_REPOS" ]; then
    GIT_REPOS=("")
else
    # Convert space-separated string to array
    # Handles both quoted and unquoted entries
    read -r -a GIT_REPOS <<< "$GIT_REPOS"
fi

echo "[+] Cloning repositories into $DEST_DIR..."

for repo in "${GIT_REPOS[@]}"; do
    # Remove quotes if any
    repo="${repo%\"}"
    repo="${repo#\"}"

    # Get repo name
    repo_name=$(basename "$repo" .git)
    target="$DEST_DIR/$repo_name"

    if [ -d "$target" ]; then
        echo "[i] Repository $repo_name already exists, pulling latest..."
        git -C "$target" pull
    else
        echo "[+] Cloning $repo..."
        git clone "$repo" "$target"
    fi
done

exec bash --rcfile /app/.bashrc -i
