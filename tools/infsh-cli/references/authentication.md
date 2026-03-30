# Authentication & Setup

## Install the CLI

**macOS / Linux:**
```bash
curl -fsSL https://cli.inference.sh | sh
```

**Windows (PowerShell):**
```powershell
irm https://cli.inference.sh | iex
```

## Login

```bash
infsh login
```

This opens a browser for authentication. After login, credentials are stored locally.

## Check Authentication

```bash
infsh me
```

Shows your user info if authenticated.

## Environment Variable

For CI/CD or scripts, set your API key:

**macOS / Linux:**
```bash
export INFSH_API_KEY=your-api-key
```

**Windows (PowerShell - current session):**
```powershell
$env:INFSH_API_KEY = "your-api-key"
```

**Windows (PowerShell - persistent):**
```powershell
[System.Environment]::SetEnvironmentVariable("INFSH_API_KEY", "your-api-key", "User")
```

The environment variable overrides the config file.

## Update CLI

```bash
infsh update
```

Or reinstall:

**macOS / Linux:**
```bash
curl -fsSL https://cli.inference.sh | sh
```

**Windows (PowerShell):**
```powershell
irm https://cli.inference.sh | iex
```

## Troubleshooting

| Error | Solution |
|-------|----------|
| "not authenticated" | Run `infsh login` |
| "command not found" | Reinstall CLI or add to PATH |
| "API key invalid" | Check `INFSH_API_KEY` or re-login |
| Command not found on Windows | Use PowerShell and run `irm https://cli.inference.sh \| iex` |

## Documentation

- [CLI Setup](https://inference.sh/docs/extend/cli-setup) - Complete CLI installation guide
- [API Authentication](https://inference.sh/docs/api/authentication) - API key management
- [Secrets](https://inference.sh/docs/secrets/overview) - Managing credentials
