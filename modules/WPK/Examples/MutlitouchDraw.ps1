New-Window -WindowState Maximized -Resource @{
    Styluses=@{}
} -On_Loaded {
    $this | 
        Enable-MultiTouch
} -On_StylusDown {
    $styluses = $this.Resources.Styluses 
    $origin = $_.GetPosition($this.Content)
    $color = 'Black', 'Pink', 'Red', 'Blue', 'Green', 'Orange','DarkRed', 'MidnightBlue', 'Maroon', 'SaddleBrown' | 
        Get-Random 
    
    $line = New-Polyline -Stroke $color -StrokeThickness 3 -Points { $origin } 
    $styluses.($_.StylusDevice.ID) = @{
        Line = $line
    }
    $line | 
        Add-ChildControl $this.Content
} -On_StylusMove {
    $styluses = $this.Resources.Styluses
    $line = $styluses.($_.StylusDevice.ID).Line
    $point = $_.GetPosition($this.Content)
    $null = $line.Points.Add($point)
} -On_StylusUp {
    $styluses = $this.Resources.Styluses 
    $styluses.($_.StylusDevice.ID).Line | 
        Move-Control -fadeOut -duration ([timespan]::FromMilliseconds(500))
    $styluses.Remove($_.StylusDevice.ID) 
} -Content {
    New-Canvas 
} -asJob