$docPath = "d:\Data\Repositories\Cortana Design\Match Official System\docs\docs"
Get-ChildItem "$docPath\*.md" | ForEach-Object {
    $file = $_
    $content = Get-Content $file.FullName
    $newContent = @()
    $inFrontmatter = $true
    $fmLineCount = 0
    
    foreach ($line in $content) {
        # Count frontmatter lines
        if ($inFrontmatter) {
            $fmLineCount++
            $newContent += $line
            
            # After line 6, exit frontmatter mode
            if ($fmLineCount -eq 6) {
                $inFrontmatter = $false
            }
        } else {
            # After frontmatter, skip standalone --- lines
            if ($line.Trim() -eq "---") {
                # Skip this line
                continue
            }
            $newContent += $line
        }
    }
    
    # Write back
    Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8
    Write-Host "Processed: $($file.Name)"
}
