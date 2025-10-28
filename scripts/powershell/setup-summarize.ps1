#!/usr/bin/env pwsh
# Setup project context summarization

[CmdletBinding()]
param(
    [switch]$Json,
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

# Show help if requested
if ($Help) {
    Write-Output "Usage: ./setup-summarize.ps1 [-Json] [-Help]"
    Write-Output "  -Json     Output results in JSON format"
    Write-Output "  -Help     Show this help message"
    exit 0
}

# Load common functions
. "$PSScriptRoot/common.ps1"

# Get repository root
$repoRoot = Get-RepoRoot

# Define paths
$projectContext = Join-Path $repoRoot 'memory/project-context.md'
$template = Join-Path $repoRoot 'templates/project-context-template.md'

# Ensure the memory directory exists
$memoryDir = Join-Path $repoRoot 'memory'
New-Item -ItemType Directory -Path $memoryDir -Force | Out-Null

# Copy template if project-context.md doesn't exist
if (-not (Test-Path $projectContext)) {
    if (Test-Path $template) {
        Copy-Item $template $projectContext -Force
        Write-Output "Created project-context.md from template at $projectContext"
    } else {
        Write-Error "Template not found at $template"
        exit 1
    }
} else {
    Write-Output "Project context already exists at $projectContext"
}

# Output results
if ($Json) {
    $result = [PSCustomObject]@{
        REPO_ROOT = $repoRoot
        PROJECT_CONTEXT = $projectContext
        TEMPLATE = $template
    }
    $result | ConvertTo-Json -Compress
} else {
    Write-Output "REPO_ROOT: $repoRoot"
    Write-Output "PROJECT_CONTEXT: $projectContext"
    Write-Output "TEMPLATE: $template"
}
