#!/usr/bin/env bash

set -e

# Parse command line arguments
JSON_MODE=false
ARGS=()

for arg in "$@"; do
    case "$arg" in
        --json)
            JSON_MODE=true
            ;;
        --help|-h)
            echo "Usage: $0 [--json]"
            echo "  --json    Output results in JSON format"
            echo "  --help    Show this help message"
            exit 0
            ;;
        *)
            ARGS+=("$arg")
            ;;
    esac
done

# Get script directory and load common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Get repository root
REPO_ROOT=$(get_repo_root)

# Define paths
PROJECT_CONTEXT="$REPO_ROOT/memory/project-context.md"
TEMPLATE="$REPO_ROOT/templates/project-context-template.md"

# Ensure the memory directory exists
mkdir -p "$REPO_ROOT/memory"

# Copy template if project-context.md doesn't exist
if [[ ! -f "$PROJECT_CONTEXT" ]]; then
    if [[ -f "$TEMPLATE" ]]; then
        cp "$TEMPLATE" "$PROJECT_CONTEXT"
        echo "Created project-context.md from template at $PROJECT_CONTEXT"
    else
        echo "Error: Template not found at $TEMPLATE"
        exit 1
    fi
else
    echo "Project context already exists at $PROJECT_CONTEXT"
fi

# Output results
if $JSON_MODE; then
    printf '{"REPO_ROOT":"%s","PROJECT_CONTEXT":"%s","TEMPLATE":"%s"}\n' \
        "$REPO_ROOT" "$PROJECT_CONTEXT" "$TEMPLATE"
else
    echo "REPO_ROOT: $REPO_ROOT"
    echo "PROJECT_CONTEXT: $PROJECT_CONTEXT"
    echo "TEMPLATE: $TEMPLATE"
fi
