
Function ParsePu ($stdout) {
    $rootPDS = @{}
    $headerLineLength = 8
    $PPDSName = $null
    $CurrentPDS = $null
    $lineCount = 0

    foreach ($line in $stdout) {
        if (($line -ne "") -and ($lineCount -gt $headerLineLength)) {
            $varName, $varType, $varLength, $varValue = $line.Split(" ").Where({ "" -ne $_ })

            # Skip this row
            if ($varName -eq "~") {
                continue
            }

            if (($varType -eq "PDS_PCH") -or ($varType -eq "PDS_I")) {
                if ($null -ne $CurrentPDS) {
                    if ($null -ne $PPDSName) {
                        
                    }
                    else {
                        $rootPDS[$CurrentPDS].Add($varName, $varValue)
                    }
                }
                else {
                    $rootPDS.Add($varName, $varValue)
                }
            }
            elseif ($varType -eq "PDS_PPDS") {
                $PPDSName = $varName
                $rootPDS.Add($varName, @())
            }
            elseif ($varType -eq "PDS_PDS") {
                $CurrentPDS = $varName
                if ($null -eq $PPDSName) {
                    $rootPDS.Add($varName, @{})
                }
                else {
                    
                }
            }
        }
        $lineCount++
    }

    $rootPDS
}

$stdout = Get-Content "./stdout.txt"
$result = ParsePu $stdout
Write-Host $result["OsVersion"]
