$zipUrl = "https://github.com/newtysquad/install-fonts/raw/refs/heads/main/fonts.zip"

$tempFolder = "$env:TEMP\fonts_zip"
$zipPath    = "$tempFolder\fonts.zip"
$extractDir = "$tempFolder\extracted"
$fontsDir   = "$env:WINDIR\Fonts"

New-Item -ItemType Directory -Force -Path $tempFolder | Out-Null

Write-Host "Baixando ZIP..."
irm $zipUrl -OutFile $zipPath

Write-Host "Extraindo arquivos..."
Expand-Archive -Path $zipPath -DestinationPath $extractDir -Force

$fontFiles = Get-ChildItem -Path $extractDir -Recurse -Include *.ttf, *.otf

$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"

foreach ($font in $fontFiles) {
    $destPath = Join-Path $fontsDir $font.Name

    Write-Host "Instalando $($font.Name)..."
    Copy-Item $font.FullName -Destination $destPath -Force

    New-ItemProperty -Path $regPath -Name $font.Name -Value $font.Name -PropertyType String -Force | Out-Null
}

Write-Host "Todas as fontes foram instaladas."