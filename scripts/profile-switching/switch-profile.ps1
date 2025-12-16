param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('wojak','fundacja','localhost')]
    [string]$Profile
)

# ⚠️ IMPORTANT: Replace placeholder values below with your actual credentials!
# This is a template - copy to C:\Users\YOUR_USERNAME\ and customize.

$profiles = @{
    'wojak' = @{
        n8n_url = 'https://YOUR-WOJAK-INSTANCE.app.n8n.cloud/api/v1'
        n8n_key = 'YOUR_WOJAK_N8N_API_KEY_HERE'
        notion_token = 'YOUR_WOJAK_NOTION_TOKEN_HERE'
        airtable_key = 'YOUR_WOJAK_AIRTABLE_KEY_HERE'
        has_airtable = $true
    }
    'fundacja' = @{
        n8n_url = 'https://YOUR-FUNDACJA-INSTANCE.wykr.es/api/v1'
        n8n_key = 'YOUR_FUNDACJA_N8N_API_KEY_HERE'
        notion_token = 'YOUR_FUNDACJA_NOTION_TOKEN_HERE'
        airtable_key = $null
        has_airtable = $false  # Set to $true and add key if needed
    }
    'localhost' = @{
        n8n_url = 'http://localhost:5678/api/v1'
        n8n_key = 'YOUR_LOCALHOST_N8N_API_KEY_HERE'
        notion_token = 'YOUR_LOCALHOST_NOTION_TOKEN_HERE'
        airtable_key = 'YOUR_LOCALHOST_AIRTABLE_KEY_HERE'
        has_airtable = $true
    }
}

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "🔄 Switching to profile: $Profile" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

$configPath = "$env:APPDATA\Claude\claude_desktop_config.json"
$config = Get-Content $configPath | ConvertFrom-Json

# Update n8n
$config.mcpServers.'n8n-current'.env.N8N_API_URL = $profiles[$Profile].n8n_url
$config.mcpServers.'n8n-current'.env.N8N_API_KEY = $profiles[$Profile].n8n_key
Write-Host "✅ n8n → $($profiles[$Profile].n8n_url)" -ForegroundColor Green

# Update notion
$config.mcpServers.'notion-current'.env.NOTION_TOKEN = $profiles[$Profile].notion_token
Write-Host "✅ notion → workspace updated" -ForegroundColor Green

# Handle airtable
if ($profiles[$Profile].has_airtable) {
    if (-not $config.mcpServers.'airtable-current') {
        $config.mcpServers | Add-Member -NotePropertyName 'airtable-current' -NotePropertyValue @{
            command = "npx"
            args = @("-y", "airtable-mcp-server")
            env = @{
                AIRTABLE_API_KEY = $profiles[$Profile].airtable_key
            }
        }
        Write-Host "✅ airtable → added" -ForegroundColor Green
    } else {
        $config.mcpServers.'airtable-current'.env.AIRTABLE_API_KEY = $profiles[$Profile].airtable_key
        Write-Host "✅ airtable → updated" -ForegroundColor Green
    }
} else {
    if ($config.mcpServers.'airtable-current') {
        $config.mcpServers.PSObject.Properties.Remove('airtable-current')
        Write-Host "❌ airtable → removed" -ForegroundColor Yellow
    }
}

$config | ConvertTo-Json -Depth 10 | Set-Content $configPath

Write-Host ""
Write-Host "🔄 Restarting Claude Desktop..." -ForegroundColor Yellow
taskkill /IM "Claude.exe" /F 2>$null
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "✨ Profile '$Profile' activated!" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host ""
Write-Host "▶️  Start Claude Desktop manually" -ForegroundColor Cyan
Write-Host ""
Read-Host "Press Enter to close"
