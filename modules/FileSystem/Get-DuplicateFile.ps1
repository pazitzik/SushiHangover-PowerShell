function Get-DuplicateFile {
    <#
    .Synopsis
    Finds files that have identical file contents.

    .Description
    The Get-DuplicateFile function detects files in a drive
    or directory that have identical file content by comparing
    an SHA1 cryptographic hash of the file contents.

    .Outputs
    Returns a System.Collections.DictionaryEntry for each collection
    of duplicate files. The key is the hash and the value is the fully
    qualified path to the duplicate files.

    .Notes
    To get the cryptographic hash of each file, Get-DuplicateFile uses
    the Get-SHA1 functions.

    .Parameter Directory
    
    Enter the path to a file system drive or directory, such as
    "C:" or "d:\test". The default is the local directory.
          
    You can enter only one directory with the Directory
    parameter. To submit multiple directories, pipe the directories
    to the Get-DuplicateFile function.

    .Parameter Recurse
    
    Searches recursively for duplicate files in all subdirectories
    of the specified directory.   
        
    .Parameter HideProgress
    
    Hides the progress bar that Get-DuplicateFile displays by
    default.
    
    .Example
    Get-DuplicateFile

    .Example
    Get-DuplicateFile c:\users -recurse
           
    .Example
    get-item c:\ps-test, d:\testing | get-duplicateFile -hideprogress
     
    .Link
    Get-SHA1
    #>

    param(
    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [Alias("FullName")]
    [String]
    $Directory,
    
    [Switch]
    $Recurse,
    
    [Switch]
    $HideProgress
    )

    Begin {
        $duplicateFinder = @{}
    }
    
    Process {
        Get-ChildItem $directory -Recurse:$recurse | 
            Get-SHA1 | 
            ForEach-Object {
                $file = $_.File
                $sha1 = $_.SHA1
                if (-not $hideProgress) { 
                    Write-Progress "Finding Duplicate Files" $file
                }
                if (-not $duplicateFinder.$sha1) {
                    $duplicateFinder.$sha1 = @()
                }
                $duplicateFinder.$sha1 += $file                
            }        
    }
    
    end {
        $duplicateFinder.GetEnumerator() | 
            Where-Object {
                $_.Value.Count -gt 1
            }
    }
}