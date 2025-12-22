$docPath = "d:\Data\Repositories\Cortana Design\Match Official System\docs\docs"
Get-ChildItem "$docPath\*.md" | ForEach-Object {
    $file = $_
    $content = Get-Content $file.FullName -Raw
    
    # Fix admonitions: if line starts with !!! and next line doesn't start with 4 spaces, indent it
    $lines = $content -split "`n"
    $newLines = @()
    $i = 0
    
    while ($i -lt $lines.Count) {
        $line = $lines[$i]
        
        # Check if this is an admonition start
        if ($line -match "^!!! (note|warning|tip|danger|info)") {
            $newLines += $line
            $i++
            
            # Check if next line(s) need indentation
            while ($i -lt $lines.Count) {
                $nextLine = $lines[$i]
                
                # Stop if we hit a blank line or another heading/section
                if ($nextLine.Trim() -eq "" -or $nextLine -match "^#{1,6} " -or $nextLine -match "^!!! ") {
                    break
                }
                
                # If line doesn't start with 4 spaces, add them
                if ($nextLine -notmatch "^    " -and $nextLine.Trim() -ne "") {
                    $newLines += "    $nextLine"
                } else {
                    $newLines += $nextLine
                }
                
                $i++
                
                # Stop if we hit a line that's not indented and isn't blank
                if ($nextLine.Trim() -ne "" -and $nextLine -notmatch "^    ") {
                    break
                }
            }
        } else {
            $newLines += $line
            $i++
        }
    }
    
    $newContent = $newLines -join "`n"
    Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8
    Write-Host "Fixed: $($file.Name)"
}
