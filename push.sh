#!/bin/bash
# Gary's Daily — Push to GitHub Pages
# Double-click this file in Git Bash, or right-click > "Open with Git Bash"

cd "$(dirname "$0")"

echo ""
echo "=== Gary's Daily — Publishing ==="
echo ""

# Check if there are uncommitted changes
if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    # No uncommitted changes — but check if there are unpushed commits
    AHEAD=$(git rev-list --count origin/main..HEAD 2>/dev/null || echo "0")
    if [ "$AHEAD" = "0" ]; then
        echo "Nothing new to publish. Everything is up to date."
        echo ""
        read -p "Press Enter to close..."
        exit 0
    else
        echo "No new changes, but $AHEAD commit(s) haven't been pushed yet."
        echo ""
    fi
else
    # Show what's changed
    echo "Changes to publish:"
    git status --short
    echo ""

    # Stage and commit
    git add .
    git commit -m "Daily update: $(date +'%Y-%m-%d')"
    echo ""
fi

echo "Pushing to GitHub..."
git push origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "Done! Your site will be live in about a minute."
else
    echo ""
    echo "Push failed — you may need to authenticate with GitHub."
    echo "Try running 'git push origin main' manually if this is your first time."
fi

echo ""
read -p "Press Enter to close..."
