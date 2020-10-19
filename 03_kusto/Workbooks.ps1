param(
      $propertiesPath="$PSScriptRoot\workbooks.properties",
      $filePathCSV="$PSScriptRoot\test_data\k6\k6_jmeter.csv",
      $outFilePathCSV="$PSScriptRoot\test_data\k6\k6_jmeter_enriched.csv",
      $dryRun=$false,
      $jmeterArgs = 'k6',
      $buildId = "$env:UserName - $(Get-Date -Format "dd/MM/yyyy HH:mm K")",
      $buildStatus = 'unknown',
      $pipelineId = "$env:UserName"
)

Import-Module $PSScriptRoot\Workbooks.psm1 -Force

Function sendJMeterDataToLogAnalytics($propertiesPath, $filePathCSV)
{
    $status = 999
    $filePathJSON = "$PSScriptRoot/test_data/results.json"
    try
    {
        $status = SendDataToLogAnalytics `
                        -propertiesFilePath "$propertiesPath" `
                        -filePathCSV "$filePathCSV" `
                        -filePathJSON "$filePathJSON"

    }catch {
        Write-Host $_
    } finally {
        Write-Host ""
        Write-Host " - Data sent with HTTP status $status"
        Write-Host " - propertiesPath $propertiesPath"
        Write-Host " - filePathJSON $filePathJSON"
    }
    return $status
}
Function addMetaDataToCSV($filePathCSV, $outFilePathCSV ){
    $inputTempFile = New-TemporaryFile
    $outputTempFile = New-TemporaryFile
    Copy-Item -Path $filePathCSV -Destination $inputTempFile
    $hash = [ordered]@{
        jmeterArgs = $jmeterArgs
        buildId = $buildId
        buildStatus = $buildStatus
        pipelineId = $pipelineId
    }
    foreach ($h in $hash.GetEnumerator()) {
        #Write-Host "$($h.Name): $($h.Value)"
        AddColumnToCSV -filePathCSV $inputTempFile -outFilePathCSV $outputTempFile -columnHeader "$($h.Name)" -columnFieldsValue "$($h.Value)"
        Copy-Item -Path $outputTempFile -Destination $inputTempFile
    }
    Copy-Item $inputTempFile -Destination $outFilePathCSV
}
Function run(){
    Write-Host "Used properties: propertiesPath $propertiesPath"
    $props = Get-Content -Path $propertiesPath
    Write-Host "$props"
    Write-Host "Results to upload: filePathCSV $filePathCSV"
    Set-Variable AZURE_POST_LIMIT -option Constant -value 30
    addMetaDataToCSV -filePathCSV $filePathCSV -outFilePathCSV $outFilePathCSV
    $sizeMB = ((Get-Item $outFilePathCSV).length/1MB)

    If ($sizeMB -gt $AZURE_POST_LIMIT){
        Write-Error "File size exceeds limit of 30 Megs: $sizeMB Megs" -ErrorAction Stop
    }
    If( -Not $dryRun)
    {
        Write-Host "Uploading file with size $sizeMB MB"
        Write-Host (Get-Content -Path $outFilePathCSV)
        $status = sendJMeterDataToLogAnalytics `
                            -propertiesPath "$propertiesPath" `
                            -filePathCSV "$outFilePathCSV"
    }else{
        $status=200
        Write-Host "Data Upload Mocked"
    }
    if ("$status" -ne "200"){
        Write-Error "Data has not been uploaded $status" -ErrorAction Stop
    }
}
run