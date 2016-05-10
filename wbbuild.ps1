# Create build directory if not exists
if (!(Test-Path -Path "build")){
    Write-Output "Creating build directory"
    $buildDirectory = New-Item -Path "build" -ItemType directory
    if ($buildDirectory){
        $buildPath = $buildDirectory.FullName
        Write-Output "Build directory created"
    }
}else{
    Write-Output "Build directory already exists - OK"
}

# Create temp directory if not exists
if (!(Test-Path -Path "build\temp")){
    Write-Output "Creating temp directory"
    $tempDirectory = New-Item -Path "build\temp" -ItemType directory
    if ($tempDirectory){
        Write-Output "Temp directory created"
    }
}else{
    Write-Output "Temp directory already exists - OK"
}

# Extract packagename & version
$path = (Convert-Path .) + "\package.xml"
if (Test-Path -Path $path){
    [xml]$file = Get-Content ($path)

    $packagename = $file.package.Attributes["name"].Value
    $version = $file.package.packageinformation.version

    # Concat exportfilepath
    $filepath = "build\" + ($packagename + "_" + $version + ".tar").Replace(" ","_")

}else{
   Throw "Packagefile could not be read"
}

# tar files
# files directory
Write-Output "Compressing 'files' directory"
7za a -ttar "build\temp\files.tar" ".\files\*" | Out-Null
if ($LASTEXITCODE -eq 0){
    Write-Output "'Files' directory compressed"
}else{
    Throw "'Files' directory could not be compressed"
}

# templates
Write-Output "Compressing 'templates' directory"
7za a -ttar "build\temp\templates.tar" ".\templates\*" | Out-Null
if ($LASTEXITCODE -eq 0){
    Write-Output "'templates' directory compressed"
}else{
    Throw "'templates' directory could not be compressed"
}

# package
Write-Output "Compressing package"
7za a -ttar $filepath "language\*" ".\build\temp\files.tar" ".\build\temp\templates.tar" "*.*" | Out-Null
if ($LASTEXITCODE -eq 0){
    Write-Output "package directory compressed"
}else{
    Throw "package directory could not be compressed"
}