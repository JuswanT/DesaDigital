$ErrorActionPreference = "Stop"

$villages = @("desa_wawatu", "desa_mata_wawatu", "desa_tanjung_tiram", "kel_lalowaru")
$safeItems = @("desa", "storage", "backup_inkremental", ".env", ".env.docker", "Dockerfile", "installer-master", "installer-master.zip", "update_opensid.ps1", "update_opensid2.ps1", "update_opensid3.ps1")

$zipPath = "OpenSID-main.zip"
$extractDir = "temp_opensid_zip"

Write-Host "Membersihkan sisa file lama..."
if (Test-Path $zipPath) { Remove-Item -Force $zipPath }
if (Test-Path $extractDir) { cmd.exe /c "rmdir /s /q $extractDir 2>nul" }

Write-Host "Mengunduh versi terbaru OpenSID dari GitHub (tanpa .git)..."
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "https://github.com/OpenSID/OpenSID/archive/refs/heads/main.zip" -OutFile $zipPath

Write-Host "Mengekstrak file ZIP..."
Expand-Archive -Path $zipPath -DestinationPath $extractDir -Force

$sourceDir = "$extractDir\OpenSID-main"

if (-not (Test-Path "$sourceDir\index.php")) {
    Write-Host "EKSTRAKSI GAGAL. ABORTING."
    exit 1
}

foreach ($village in $villages) {
    Write-Host "Processing $village..."
    
    $items = Get-ChildItem -Path $village -Force
    foreach ($item in $items) {
        if ($safeItems -notcontains $item.Name) {
            Write-Host "  Removing $($item.Name)..."
            if ($item.PSIsContainer) {
                cmd.exe /c "rmdir /s /q `"$($item.FullName)`" 2>nul"
            } else {
                cmd.exe /c "del /f /q /a `"$($item.FullName)`" 2>nul"
            }
        } else {
            Write-Host "  Skipping safe item $($item.Name)..."
        }
    }
    
    Write-Host "  Copying new OpenSID files to $village..."
    Get-ChildItem -Path $sourceDir -Force | Copy-Item -Destination $village -Recurse -Force
}

Write-Host "Cleaning up..."
if (Test-Path $zipPath) { Remove-Item -Force $zipPath }
if (Test-Path $extractDir) { cmd.exe /c "rmdir /s /q $extractDir 2>nul" }

Write-Host "Update completed successfully!"
