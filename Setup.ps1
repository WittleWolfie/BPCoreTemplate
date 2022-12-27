function Get-Folder([string]$desc, [string]$dir="")
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = $desc
    $foldername.rootfolder = "MyComputer"
    $foldername.SelectedPath = $dir

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}

$wrathPath =
  Get-Folder `
    -Desc "Select your Wrath install directory (contains Wrath.exe)" `
    -Dir "C:\Program Files (x86)\Steam\steamapps\common\Pathfinder Second Adventure"
[System.Environment]::SetEnvironmentVariable('WrathPath', $wrathPath, [System.EnvironmentVariableTarget]::User)

$currentDir = Get-Location

$modProject = Get-Folder -Desc "Select your mod project directory" -Dir $currentDir
$projectFiles = Join-Path -Path $currentDir -ChildPath "BasicTemplate\*"
Copy-Item -Path $projectFiles -Destination $modProject -Recurse -Force

$unityProject = Get-Folder -Desc "Select your Unity project directory" -Dir $currentDir
$unityFiles = Join-Path -Path $currentDir -ChildPath "Assets"
Copy-Item -Path $unityFiles -Destination $unityProject -Recurse -Force

$modName = Read-Host -Prompt "What is the name of your mod?"
Get-ChildItem -Path $modProject -Recurse -Include *BasicTemplate* | Rename-Item -NewName { $_.Name -replace "BasicTemplate",$modName} -Force

$modFiles = Get-ChildItem -Path $modProject -Recurse -File
foreach($file in $modFiles)
{
  (Get-Content -Path $file.FullName -Raw) -replace "BasicTemplate",$modName | Set-Content -Path $file.FullName -Force
}

$unityFiles = Get-ChildItem -Path $unityProject -Recurse -File
foreach($file in $unityFiles)
{
  (Get-Content -Path $file.FullName -Raw) -replace "BasicTemplate",$modName | Set-Content -Path $file.FullName -Force
}

$shell = New-Object -ComObject "WScript.Shell"
$button = $shell.Popup("Click OK to exit", 0, "Done", 0)