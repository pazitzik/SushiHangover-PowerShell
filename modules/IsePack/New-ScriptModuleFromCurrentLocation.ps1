function New-ScriptModuleFromCurrentLocation {
    <#
    .Synopsis
        Creates a new basic script module (.PSM1) from location of the current file
    .Description
        Creates a new basic script module (.PSM1) from location of the current file
        All .ps1 files in the same directory as the current file will be included in 
        the module.
        
        Does not overwrite existing modules at this location.

    .Example
        New-ScriptModuleFromCurrentLocation        
    #>
    param()
    $location = Split-Path $psise.CurrentFile.FullPath
    $locationName = Split-Path $location -Leaf
    $text = ""
    Get-ChildItem $location -Filter *.ps1 | ForEach-Object {
        $text += ('. $psScriptRoot\' + $_.Name + [Environment]::NewLine)
    }
    $modulePath = Join-Path $location "$locationName.psm1"
    if (Test-Path -ErrorAction SilentlyContinue $modulePath) {
        return
    }
    [IO.File]::WriteAllText($modulePath, $text)
    $psise.CurrentPowerShellTab.Files.Add($modulePath)
}