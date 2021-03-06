function Add-SwitchStatement
{
    <#
    .Synopsis
        Adds a Switch Statement to the current file
    .Description
        Adds a Switch statement to the current file within the integrated scripting environment
    .Example
        Add-SwitchStatement 
    #>
    param()
    $l = $psise.CurrentFile.Editor.CaretLine
    $c = $psise.CurrentFile.Editor.CaretColumn
    $x = ''
    if ($c -ne 0)
    {
        $x = ' ' * ($c - 1)
    }
    $psise.CurrentFile.Editor.InsertText("switch(`$condition) {`n" + $x + "    default { }`n" + $x + "}")
    $psise.CurrentFile.Editor.SetCaretPosition($l, $c + 3)    
}
