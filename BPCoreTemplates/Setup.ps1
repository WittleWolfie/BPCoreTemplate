Function Get-Folder($initialDirectory="")
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select your Pathfinder install directory (contains Wrath.exe)"
    $foldername.rootfolder = "MyComputer"
    $foldername.SelectedPath = $initialDirectory

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}

$wrathPath = Get-Folder("C:\Program Files (x86)\Steam\steamapps\common\Pathfinder Second Adventure")
[System.Environment]::SetEnvironmentVariable('WrathPath', $wrathPath, [System.EnvironmentVariableTarget]::User)

