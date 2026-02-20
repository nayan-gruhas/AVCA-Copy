#!/bin/bash
# Portfolio Tracker - New File Detection Script
# Compares files on disk against the processed tracker in CLAUDE.md
# Usage: bash detect_new_files.sh

ROOT="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_MD="$ROOT/CLAUDE.md"

echo "==================================="
echo "Portfolio Tracker - New File Detector"
echo "==================================="
echo ""

if [ ! -f "$CLAUDE_MD" ]; then
    echo "ERROR: CLAUDE.md not found at $CLAUDE_MD"
    echo "Make sure you're running this from the portfolio-tracker directory."
    exit 1
fi

new_count=0

# Find all files in company folders (skip Claude Summary and hidden dirs)
while IFS= read -r filepath; do
    # Get relative path from root
    relpath="${filepath#$ROOT/}"
    filename=$(basename "$filepath")

    # Check if this file is already in the tracker
    if grep -qF "$filename" "$CLAUDE_MD" 2>/dev/null; then
        : # Already tracked
    else
        if [ $new_count -eq 0 ]; then
            echo "NEW FILES FOUND:"
            echo "-----------------------------------"
        fi
        new_count=$((new_count + 1))
        # Get file size
        size=$(du -h "$filepath" | cut -f1)
        # Get modification date
        moddate=$(date -r "$filepath" "+%Y-%m-%d %H:%M" 2>/dev/null || stat -c "%y" "$filepath" 2>/dev/null | cut -d. -f1)
        echo "  [$new_count] $relpath"
        echo "      Size: $size | Modified: $moddate"
        echo ""
    fi
done < <(find "$ROOT" -type f \
    -not -path "*/Claude Summary/*" \
    -not -path "*/.claude/*" \
    -not -path "*/.git/*" \
    -not -name "CLAUDE.md" \
    -not -name "README.md" \
    -not -name "detect_new_files.sh" \
    -not -name ".gitignore" \
    -not -name ".*" \
    | sort)

if [ $new_count -eq 0 ]; then
    echo "All files are tracked. No new updates found."
else
    echo "-----------------------------------"
    echo "Total new files: $new_count"
    echo ""
    echo "To process, start a Claude Code session and say:"
    echo "  'Process the new updates'"
fi

echo ""
echo "Last run: $(date '+%Y-%m-%d %H:%M:%S')"
