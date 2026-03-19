#!/bin/bash
# Gary's Daily — Push to GitHub Pages
# Double-click this file in Git Bash, or right-click > "Open with Git Bash"

cd "$(dirname "$0")"

echo ""
echo "=== Gary's Daily — Publishing ==="
echo ""

# Check if there are changes to commit
if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    echo "Nothing new to publish. Everything is up to date."
    echo ""
    read -p "Press Enter to close..."
    exit 0
fi

# Show what's changed
echo "Changes to publish:"
git status --short
echo ""

# Stage, commit, and push
git add .
git commit -m "Daily update: $(date +'%Y-%m-%d')"
echo ""

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
