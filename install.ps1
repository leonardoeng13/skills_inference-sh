# inference.sh CLI installer for Windows (PowerShell)
# Usage: irm https://raw.githubusercontent.com/inference-sh/skills/main/install.ps1 | iex
#
# Environment variables:
#   $env:INSTALL_DIR  — override install directory (default: $HOME\.local\bin)

$ErrorActionPreference = 'Stop'

& {
    # --- Architecture detection ---
    $arch = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture
    switch ($arch) {
        'X64'   { $ARCH = 'amd64' }
        'Arm64' { $ARCH = 'arm64' }
        default { throw "Unsupported architecture: $arch" }
    }

    # --- Install directory ---
    if ($env:INSTALL_DIR) {
        $INSTALL_DIR = $env:INSTALL_DIR
    } else {
        $INSTALL_DIR = Join-Path $HOME '.local' | Join-Path -ChildPath 'bin'
    }

    # --- Download manifest ---
    Write-Host "Fetching release manifest..."
    try {
        $manifest = Invoke-RestMethod -Uri 'https://dist.inference.sh/cli/manifest.json' -UseBasicParsing
    } catch {
        throw "Failed to fetch manifest from https://dist.inference.sh/cli/manifest.json: $_"
    }

    # --- Find Windows binary ---
    $entry = $manifest.files | Where-Object { $_.url -match "windows-$ARCH" } | Select-Object -First 1
    if (-not $entry) {
        throw "No Windows $ARCH binary found in the manifest."
    }

    $downloadUrl = $entry.url
    $expectedSha  = $entry.sha256

    Write-Host "Downloading infsh ($ARCH) from $downloadUrl ..."

    $tmpZip = Join-Path $env:TEMP 'inferencesh-cli.zip'
    try {
        Invoke-WebRequest -Uri $downloadUrl -OutFile $tmpZip -UseBasicParsing
    } catch {
        throw "Download failed: $_"
    }

    # --- SHA-256 verification ---
    if ($expectedSha) {
        Write-Host "Verifying checksum..."
        $actualSha = (Get-FileHash -Path $tmpZip -Algorithm SHA256).Hash.ToLower()
        if ($actualSha -ne $expectedSha.ToLower()) {
            Remove-Item -Force $tmpZip -ErrorAction SilentlyContinue
            throw "Checksum mismatch!`n  expected: $expectedSha`n  got:      $actualSha"
        }
        Write-Host "Checksum OK."
    }

    # --- Extract ---
    if (-not (Test-Path $INSTALL_DIR)) {
        New-Item -ItemType Directory -Path $INSTALL_DIR -Force | Out-Null
    }

    Expand-Archive -Path $tmpZip -DestinationPath $INSTALL_DIR -Force
    Remove-Item -Force $tmpZip -ErrorAction SilentlyContinue

    # --- PATH update ---
    $userPath = [System.Environment]::GetEnvironmentVariable('PATH', 'User')
    if (-not $userPath) { $userPath = '' }
    $userPath = $userPath.TrimEnd(';')
    if ($userPath -notlike "*$INSTALL_DIR*") {
        Write-Host "Adding $INSTALL_DIR to your PATH..."
        $newUserPath = if ($userPath) { "$userPath;$INSTALL_DIR" } else { $INSTALL_DIR }
        [System.Environment]::SetEnvironmentVariable('PATH', $newUserPath, 'User')
        # Also update PATH for the current session
        if ($env:PATH -notlike "*$INSTALL_DIR*") {
            $env:PATH = "$env:PATH;$INSTALL_DIR"
        }
        Write-Host "PATH updated. You may need to open a new terminal for the change to take effect."
    }

    # --- Done ---
    Write-Host ""
    Write-Host "infsh installed successfully to $INSTALL_DIR"
    Write-Host "Run 'infsh login' to get started."
}
