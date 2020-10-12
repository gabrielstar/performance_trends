param(
    $resultsPath = "$PSScriptRoot\test_data\k6",
    $resultsFile = "k6.csv",
	$outputFile = "k6_jmeter.csv",
    $dryRun = $false
)

Function resetFile($resultsPath, $convertedFileName)
{
    $header = "timeStamp,elapsed,label,responseCode,responseMessage,threadName,dataType,success,failureMessage,bytes,sentBytes,grpThreads,allThreads,URL,Latency,IdleTime,Connect"
    if (Test-Path "$resultsPath\$convertedFileName")
    {
        Remove-Item "$resultsPath\$convertedFileName"
    }
    New-Item -Path $resultsPath -Name $convertedFileName -ItemType "file"
    Add-Content -Path "$resultsPath\$convertedFileName" -Value $header

}
Function ConvertToJmeterRow($row,$rootURL){
	$r=$row.split(',')
	$timeStamp=$r[1] -as [int]
    $timeStamp = $timeStamp * 1000
	$elapsed=[Math]::Floor([decimal]($r[2])) #round to integer ms
	$label=$r[8] -replace $rootURL,''
	$URL=$r[8]
	$responseCode=$r[11]
	$responseMessage='success'
	$success='true'
	If( $responseCode -ne "200"){
		$responseMessage='error'
		$success='false'
	}
	$jmeter_row = "$timeStamp,$elapsed,$label,$responseCode,$responseMessage,threadName,dataType,$success,failureMessage,bytes,sentBytes,grpThreads,allThreads,$URL,Latency,IdleTime,Connect"
	return $jmeter_row
}
Function ConvertJSONstoJMeterCSV($resultsPath, $resultsFile, $outputFile)
{
    resetFile -resultsPath $resultsPath -convertedFileName $outputFile
	Get-Content "$resultsPath\$resultsFile" | ForEach-Object {
		if($_ -match "http_req_duration,.*"){
			$row=$_ -replace 'host.docker.internal', 'localhost'
			$row = convertToJmeterRow -row $row -rootURL 'http://localhost:3000'
			Add-Content -Path "$resultsPath\$outputFile" -Value $row
		}
	}
}

if (-Not $dryRun)
{
    Write-Host "Converting ..."
    ConvertJSONstoJmeterCSV -resultsPath $resultsPath -resultsFile $resultsFile -outputFile $outputFile
}
else
{
    Write-Host "Dry-run"
}