#!/bin/bash
# Gary's Daily — Push to GitHub Pages
# Double-click this file in Git Bash, or right-click > "Open with Git Bash"

cd "$(dirname "$0")"

echo ""
echo "=== Gary's Daily — Publishing ==="
echo ""

# --- 0. Clear stale lock files that silently block commits ---------------------
# A leftover .git/index.lock is what caused past "Done!" runs to publish nothing.
for lock in .git/index.lock .git/HEAD.lock .git/objects/maintenance.lock; do
    if [ -e "$lock" ]; then
        echo "Found stale lock: $lock — removing..."
        rm -f "$lock"
        if [ -e "$lock" ]; then
            echo "  WARNING: could not remove $lock."
            echo "  Close any open editor/Git processes (and pause OneDrive sync) then re-run."
        fi
    fi
done

# --- 1. Stage and commit any changes -------------------------------------------
if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    echo "No file changes to commit."
else
    echo "Changes to publish:"
    git status --short
    echo ""

    git add -A
    if [ $? -ne 0 ]; then
        echo ""
        echo "!!! ERROR: 'git add' failed — NOTHING was committed."
        echo "    Your changes are NOT published. Fix the error above and re-run."
        echo ""
        read -p "Press Enter to close..."
        exit 1
    fi

    COMMIT_OUTPUT=$(git commit -m "Daily update: $(date +'%Y-%m-%d')" 2>&1)
    COMMIT_STATUS=$?
    echo "$COMMIT_OUTPUT"
    if [ $COMMIT_STATUS -ne 0 ]; then
        if echo "$COMMIT_OUTPUT" | grep -qi "nothing to commit"; then
            echo "(Working tree already matches the last commit — continuing to push.)"
        else
            echo ""
            echo "!!! ERROR: 'git commit' failed — your changes are NOT committed."
            echo "    The site was NOT updated. Fix the error above and re-run."
            echo ""
            read -p "Press Enter to close..."
            exit 1
        fi
    fi
    echo ""
fi

# --- 2. Is there anything to push? ---------------------------------------------
AHEAD=$(git rev-list --count origin/main..HEAD 2>/dev/null || echo "0")
if [ "$AHEAD" = "0" ]; then
    echo "Nothing new to push — local and GitHub are already in sync."
    echo ""
    read -p "Press Enter to close..."
    exit 0
fi

# --- 3. Push -------------------------------------------------------------------
echo "Pushing $AHEAD commit(s) to GitHub..."
git push origin main
PUSH_STATUS=$?
echo ""

if [ $PUSH_STATUS -ne 0 ]; then
    echo "!!! PUSH FAILED — the site was NOT updated."
    echo "    You may need to authenticate with GitHub."
    echo "    Try running 'git push origin main' manually."
    echo ""
    read -p "Press Enter to close..."
    exit 1
fi

# --- 4. Verify GitHub actually matches local -----------------------------------
git fetch origin main --quiet 2>/dev/null
STILL_AHEAD=$(git rev-list --count origin/main..HEAD 2>/dev/null || echo "?")
if [ "$STILL_AHEAD" = "0" ]; then
    echo "Done! Verified — GitHub matches your local copy. Site live in about a minute."
else
    echo "WARNING: push reported success but GitHub still appears $STILL_AHEAD commit(s) behind."
    echo "         Re-run this script, or check 'git status' and 'git log'."
fi

echo ""
read -p "Press Enter to close..."
