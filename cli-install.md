# Install CLI

## macOS / Linux

```sh
curl -fsSL https://cli.inference.sh | sh
infsh login
```

## Windows

Open **PowerShell** and run:

```powershell
irm https://cli.inference.sh | iex
infsh login
```

> **No PowerShell?** You can also use [Git Bash](https://git-scm.com/downloads) or [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) and run the macOS/Linux command above.

## What does the installer do?

The install script detects your OS and architecture, downloads the correct binary from dist.inference.sh, verifies its SHA-256 checksum, and places it in your PATH. That's it — no elevated permissions, no background processes, no telemetry. If you have cosign installed, the installer also verifies the Sigstore signature automatically.

## Manual install (Windows)

If you prefer not to run the install script, download the Windows binary manually:

1. Open PowerShell and run:

```powershell
# Download the manifest to find the Windows binary URL
$manifest = Invoke-RestMethod -Uri https://dist.inference.sh/cli/manifest.json
$entry = $manifest.files | Where-Object { $_.url -match 'windows-amd64' } | Select-Object -First 1
Invoke-WebRequest -Uri $entry.url -OutFile "$env:TEMP\inferencesh-cli.zip"
Expand-Archive -Path "$env:TEMP\inferencesh-cli.zip" -DestinationPath "$env:USERPROFILE\.local\bin" -Force
# Add to PATH if needed (restart terminal after this)
[System.Environment]::SetEnvironmentVariable("PATH", "$env:PATH;$env:USERPROFILE\.local\bin", "User")
```

2. Open a new terminal and verify:

```powershell
infsh version
infsh login
```
