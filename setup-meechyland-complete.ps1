# MeechyLand Complete Setup Script
# Downloads plugins, creates command file for kits, territories, games, and AI
# Run this with the server STOPPED

$ErrorActionPreference = "Continue"
$root = "C:\MeechyLand"
$plugins = "$root\plugins"

Write-Host "=== MeechyLand Complete Setup ===" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $plugins | Out-Null

# Core plugins
$downloads = @{
    "LuckPerms.jar"   = "https://download.luckperms.net/1515/bukkit/loader/LuckPerms-Bukkit-5.4.141.jar"
    "EssentialsX.jar" = "https://github.com/EssentialsX/Essentials/releases/download/2.20.1/EssentialsX-2.20.1.jar"
    "Vault.jar"       = "https://github.com/MilkBowl/Vault/releases/download/1.7.3/Vault.jar"
}

foreach ($name in $downloads.Keys) {
    Write-Host "Downloading $name..." -ForegroundColor Yellow
    try {
        Invoke-WebRequest -Uri $downloads[$name] -OutFile "$plugins\$name" -ErrorAction Stop
        Write-Host "  OK" -ForegroundColor Green
    } catch {
        Write-Host "  FAILED: $_" -ForegroundColor Red
    }
}

# Update server.properties
$props = "$root\server.properties"
if (Test-Path $props) {
    $content = Get-Content $props -Raw
    $content = $content -replace '(?m)^motd=.*', 'motd=§6§lMeechyLand §r§7| §dPowers §a& §bTerritories'
    $content = $content -replace '(?m)^online-mode=.*', 'online-mode=false'
    Set-Content $props $content -NoNewline
    Write-Host "server.properties updated" -ForegroundColor Green
}

# Full command file
$commands = @"
# === MeechyLand Complete Setup ===
# Paste these into the server console after it starts
# Manually add these JARs first (1.12 builds):
# - GriefPrevention
# - WorldEdit
# - MythicMobs (optional AI)
# - Citizens (optional NPCs)

op YourMinecraftName

# Territories
/adjustbonusclaimblocks Zoey 8000
/adjustbonusclaimblocks Noah 8000
/adjustbonusclaimblocks Mila 15000
/adjustbonusclaimblocks BigMeech67 15000
/adjustbonusclaimblocks DAD 20000
/adminclaims

# Permissions
/lp user BigMeech67 permission set essentials.* true
/lp user BigMeech67 permission set worldedit.* true
/lp user Mila permission set worldedit.* true
/lp user DAD permission set worldedit.* true
/lp user Zoey permission set essentials.home true
/lp user Noah permission set essentials.home true

# Kits (create by putting items in inventory first)
/kit create starter
/kit create builder
/kit starter Zoey
/kit starter Noah
/kit starter Mila
/kit starter BigMeech67
/kit builder Mila
/kit builder BigMeech67

# Games (examples - paste arenas with WorldEdit)
# //schem load parkour-arena
# //paste
# //schem load spleef
# //paste

# AI (after adding MythicMobs or Citizens)
# /mm mobs spawn CustomMob
# /npc create MilaGuide
"@

Set-Content -Path "$root\full-setup-commands.txt" -Value $commands -Encoding UTF8

Write-Host "`n=== DONE ===" -ForegroundColor Green
Write-Host "Plugins: $plugins"
Write-Host "Commands: $root\full-setup-commands.txt"
Write-Host ""
Write-Host "Manual steps:" -ForegroundColor Cyan
Write-Host "1. Download 1.12 builds of GriefPrevention + WorldEdit and put in plugins"
Write-Host "2. Optional: MythicMobs + Citizens for AI/NPCs"
Write-Host "3. Restart server"
Write-Host "4. Paste commands from full-setup-commands.txt"
Write-Host ""
Write-Host "Press any key to close..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
