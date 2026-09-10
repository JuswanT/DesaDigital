$villages = @("desa_wawatu", "desa_mata_wawatu", "desa_tanjung_tiram", "kel_lalowaru")
$safeItems = @("desa", "storage", "backup_inkremental", ".env", ".env.docker", "Dockerfile", "installer-master", "installer-master.zip", "update_opensid.ps1")

$tempDir = "temp_opensid"

Write-Host "Membersihkan folder temp lama (jika ada)..."
if (Test-Path $tempDir) {
    cmd.exe /c "rmdir /s /q $tempDir 2>nul"
}

Write-Host "Cloning OpenSID latest to $tempDir..."
git clone https://github.com/OpenSID/OpenSID.git $tempDir

Write-Host "Menghapus .git (agar tidak conflict)..."
cmd.exe /c "rmdir /s /q $tempDir\.git 2>nul"

foreach ($village in $villages) {
    Write-Host "Processing $village..."
    
    $items = Get-ChildItem -Path $village -Force
    foreach ($item in $items) {
        if ($safeItems -notcontains $item.Name) {
            Write-Host "  Removing $($item.Name)..."
            if ($item.PSIsContainer) {
                # Menggunakan rmdir bawaan Windows yang lebih tangguh menangani file Read-Only/terkunci
                cmd.exe /c "rmdir /s /q `"$($item.FullName)`" 2>nul"
            } else {
                cmd.exe /c "del /f /q /a `"$($item.FullName)`" 2>nul"
            }
        } else {
            Write-Host "  Skipping safe item $($item.Name)..."
        }
    }
    
    Write-Host "  Copying new OpenSID files to $village..."
    Get-ChildItem -Path $tempDir -Force | Copy-Item -Destination $village -Recurse -Force
}

Write-Host "Cleaning up $tempDir..."
cmd.exe /c "rmdir /s /q $tempDir 2>nul"

Write-Host "Update completed successfully!"
