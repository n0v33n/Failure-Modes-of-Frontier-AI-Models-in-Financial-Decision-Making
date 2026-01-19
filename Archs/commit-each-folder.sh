#!/usr/bin/env bash
set -euo pipefail

# Only top-level directories that are NOT already tracked/committed
for dir in */; do
    # Skip if not a real directory
    [ -d "$dir" ] || continue

    # Remove trailing slash for clean name
    folder="${dir%/}"
    name=$(basename "$folder")

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Folder: $name"

    # Add **only this folder**
    git add -- "$folder" 2>/dev/null || { echo "→ git add failed"; continue; }

    # Check if we actually staged anything new
    if git diff --cached --quiet; then
        echo "→ Nothing new to commit (already tracked or empty)"
        git restore --staged -- "$folder" 2>/dev/null
        continue
    fi

    # Commit
    git commit -m "Add folder: $name" || { echo "→ Commit failed"; continue; }

    echo "→ Committed successfully"

    # Optional: push immediately (uncomment if you want)
    # git push || echo "→ Push failed - continuing anyway"

    sleep 5
done

echo
echo "Finished processing all top-level folders."
git status
